--imports
import Data.Char (toUpper)
import Data.List (sortBy, maximumBy, minimumBy)






--tipos de dados


data Prova = Prova
    { valorNota :: Double  -- nota que o cara tirou
    , pesoNota  :: Double  
    } deriving (Show)

data ProvaFinal = SemFinal         -- não precisou fazer
               | Pendente                -- vai fazer mas ainda não fez
               | Feita Double     -- nota dele
               deriving (Show)

data Disciplina = Disciplina
    { nomeDisciplina  :: String   
    , provas          :: [Prova]  
    , pesoMediaFinal  :: Double   -- peso da média regular na conta final
    , pesoProvaFinal  :: Double   -- peso da prova final na conta final
    , mediaAprovacao  :: Double   -- nota mínima pra aprovação
    } deriving (Show)

data Aluno = Aluno
    { nomeAluno   :: String                    
    , disciplinas :: [(Disciplina, ProvaFinal)] -- disciplina + situação da final
    } deriving (Show)

type Alunos = [Aluno]






-- funções auxiliares


mediaPonderada :: [Prova] -> Double --recebe uma lista de provas e calcula a média ponderada
mediaPonderada provas = sum (map (\p -> valorNota p * pesoNota p) provas)

aprovadoDireto :: Disciplina -> Bool
aprovadoDireto disciplina = mediaPonderada (provas disciplina) >= mediaAprovacao disciplina

notaNecessaria :: Disciplina -> Double -- só faz sentido chamar isso se o aluno não for aprovado direto. tem que especificar no menu
notaNecessaria disciplina = (mediaAprovacao disciplina - mediaPonderada (provas disciplina) * pesoMediaFinal disciplina) / pesoProvaFinal disciplina

mediaLista :: [Double] -> Double
mediaLista lista = sum lista / fromIntegral (length lista)

mediaAluno :: Aluno -> Double
mediaAluno aluno = mediaLista (map (\(d, _) -> mediaPonderada (provas d)) (disciplinas aluno))
{- 
    recebe um Aluno, extrai sua lista de (Disciplina, ProvaFinal),
    desconsidera o ProvaFinal com (_), calcula a mediaPonderada de cada Disciplina,
    e por fim tira a média dessas médias com mediaLista
-}

mediaGeralNotas :: Alunos -> Double
mediaGeralNotas alunos =
    mediaLista (map mediaAluno alunos)
{-
    recebe uma lista de Alunos,
    calcula a média de cada aluno usando mediaAluno,
    monta uma lista com essas médias,
    e o caba tira a média geral com mediaLista
-}


disciplinaAprovada :: (Disciplina, ProvaFinal) -> Bool -- faz o calulco e mostra se o aluno passou em uma disciplina especifica
disciplinaAprovada (disciplina, SemFinal)  = aprovadoDireto disciplina
disciplinaAprovada (disciplina, Pendente)  = False
disciplinaAprovada (disciplina, Feita nota) = (mediaPonderada (provas disciplina) * pesoMediaFinal disciplina) + 
                                                (nota * pesoProvaFinal disciplina) >= mediaAprovacao disciplina

alunoAprovado :: Aluno -> Bool -- basicamente diz se um aluno está aprovado em todas as disciplinas
alunoAprovado aluno = all disciplinaAprovada (disciplinas aluno) 






maiorMedia :: Alunos -> IO()
maiorMedia alunos = do
    print(maximum (map mediaAluno alunos))
{-
    recebe uma lista de Alunos,
    calcula a média de cada um com mediaAluno,
    monta uma lista dessas médias,
    e retorna a maior delas com maximum
-}

adicionarAluno :: Alunos -> IO Alunos
adicionarAluno alunos = do
    putStrLn "\nNome do aluno:"
    nome <- getLine
    let novoAluno = Aluno { nomeAluno = nome, disciplinas = [] }
    return (alunos ++ [novoAluno])
{-
recebe a lista de alunos, pede o nome, 
cria um aluno sem disciplinas, concatena na lista atual retorna a lista atualizada
-}

adicionarDisciplina :: Alunos -> IO Alunos
adicionarDisciplina alunos = do
    putStrLn "\nNome do aluno:"
    nome <- getLine
    if nome `elem` map nomeAluno alunos
        then do
            putStrLn "Nome da disciplina:"
            nomeDisc <- getLine
            putStrLn "Média de aprovação:"
            media <- readLn
            putStrLn "Peso da média final:"
            pesoMF <- readLn
            putStrLn "Peso da prova final:"
            pesoPF <- readLn
            let novaDisc = Disciplina { nomeDisciplina = nomeDisc, provas = [], pesoMediaFinal = pesoMF, pesoProvaFinal = pesoPF, mediaAprovacao = media }
            let alunosAtualizados = map (\a -> if nomeAluno a == nome
                                               then a { disciplinas = disciplinas a ++ [(novaDisc, Pendente)] }
                                               else a) alunos
            return alunosAtualizados
        else do
            putStrLn "Aluno não encontrado!"
            return alunos
{- 
recebe a lista de alunos, pede o nome do aluno e os dados da disciplina,
cria a disciplina e adiciona ela ao aluno correspondente, retornando a lista atualizada
-}


mostrarMediaGeral :: Alunos -> IO()
mostrarMediaGeral alunos = do
    print (mediaGeralNotas alunos)
{- 
    recebe a lista de alunos,
    calcula a média geral das notas,
    e mostra o resultado na tela
-}


ranking :: Alunos -> IO()
ranking alunos = do
    let ordenados =
            sortBy (\a b -> compare (mediaAluno b) (mediaAluno a)) alunos

    mapM_ (\a ->
        putStrLn (nomeAluno a ++ " - " ++ show (mediaAluno a)))
        ordenados
{- 
    recebe a lista de alunos,
    ordena da maior média para a menor,
    e mostra o ranking na tela
-}


porcentagemAprovacao :: Alunos -> IO() -- volta a porcentagem de alunos aprovados em todas as disciplinas
porcentagemAprovacao alunos = do
    let aprovados = length (filter alunoAprovado alunos)
    let total = length alunos
    let porcentagem = fromIntegral aprovados / fromIntegral total * 100
    putStrLn ("Aprovados: " ++ show porcentagem ++ "%")




disciplinaMaisDificil :: Alunos -> IO() 
disciplinaMaisDificil alunos = do
    let todasDisciplinas = concatMap (map fst . disciplinas) alunos -- concatena as disciplinas de todos os alunos
    let maisDificil = minimumBy (\a b -> compare (mediaPonderada (provas a)) (mediaPonderada (provas b))) todasDisciplinas -- vai comparando as médias ponderadas de todas as provas e volta a com a menor média
    putStrLn ("Disciplina mais difícil: " ++ nomeDisciplina maisDificil)



mostrarNotaNecessaria :: Alunos -> IO() -- o usuário passa o nome de um aluno, passa a disciplina que quer consultar e o método fala o estado atual do aluno ou a nota necessária
mostrarNotaNecessaria alunos = do
    putStrLn "\nNome do aluno:"
    nome <- getLine
    let alunoEncontrado = filter (\a -> nomeAluno a == nome) alunos -- buscando se o aluno existe
    if null alunoEncontrado
        then putStrLn "Aluno não encontrado!"
        else do
            let aluno = head alunoEncontrado
            putStrLn "Nome da disciplina:"
            nomeDisc <- getLine
            let discEncontrada = filter (\(d, _) -> nomeDisciplina d == nomeDisc) (disciplinas aluno) -- procurando se a disciplina exite
            if null discEncontrada
                then putStrLn "Disciplina não encontrada!"
                else do
                    let (disc, situacao) = head discEncontrada
                    case situacao of -- econtrou a disciplina e vai dizer a situação do aluno nela
                        SemFinal -> putStrLn "Aluno já aprovado direto, não precisa de final!"
                        Feita _  -> putStrLn "Aluno já fez a final!"
                        Pendente -> putStrLn ("Nota necessária na final: " ++ show (notaNecessaria disc))


-- funcionalidades

-- ✅ média ponderada configurável por disciplina

-- ✅Calcular Ranking de notas

-- ✅Calcular Porcentagem de Aprovação

-- ✅Calcular e mostrar maior média

-- ✅Calcular média geral das notas

-- Calcular nota necessária na final

-- ✅Calcular a disciplina mais difícil


escolha :: Char -> Alunos -> IO()
escolha letra alunos
    | toUpper letra == 'A' = do
        alunosAtualizados <- adicionarAluno alunos 
        loop alunosAtualizados
    | toUpper letra == 'I' = do
        alunosAtualizados <- adicionarDisciplina alunos
        loop alunosAtualizados
   -- | toUpper letra == 'E' = editarMateria >> loop alunos
    | toUpper letra == 'M' = mostrarMediaGeral alunos >> loop alunos
    | toUpper letra == 'T' = maiorMedia alunos >> loop alunos
   -- | toUpper letra == 'P' = porcentagemAP >> loop alunos                           
   -- | toUpper letra == 'F' = notaNecessaria >> loop alunos
   -- | toUpper letra == 'D' = disMaisDificil >> loop alunos
    | toUpper letra == 'R' = ranking alunos >> loop alunos
    | toUpper letra == 'S' = putStrLn "\nAté Mais!"
    | otherwise = putStrLn "\nResposta Inválida" >> loop alunos



-- main

loop :: Alunos -> IO()
loop alunos = do
        
    putStrLn "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    putStrLn "         Sistema de Notas          "
    putStrLn "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    putStrLn "Selecione uma opção:\n"
    putStrLn ("Adicionar Aluno(A)\n\
        \Adicionar Disciplina(I)\n\
        \Editar Matéria(E)\n\
        \Media Geral das Notas(M)\n\
        \Maior Média(T)\n\
        \Porcentagem de Aprovação(P)\n\
        \Nota Necessaria na prova Final(F)\n\
        \Disciplina mais Difícil(D)\n\
        \Ranking de Notas(R)\n\
        \Sair(S)\n")
    letra <- getChar
    escolha letra alunos

main :: IO()
main = loop []
