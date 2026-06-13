--imports
import Data.Char (toUpper)
import Data.List (sortBy, maximumBy, minimumBy)






--tipos de dados

data Prova = Prova
    { valorNota :: Double  -- nota que o aluno tirou
    , pesoNota  :: Double  -- peso dessa prova no cálculo da média
    } deriving (Show)

data ProvaFinal = SemFinal      -- aluno foi aprovado direto, não precisa fazer final
               | Pendente       -- vai fazer a final, mas ainda não fez
               | Feita Double   -- já fez a final; guarda a nota
               deriving (Show)

-- configuração da disciplina, definida uma vez e compartilhada por toda a turma
data Disciplina = Disciplina
    { nomeDisciplina :: String
    , pesoMediaFinal :: Double  -- peso da média regular na nota final
    , pesoProvaFinal :: Double  -- peso da prova final na nota final
    , mediaAprovacao :: Double  -- nota mínima para aprovação
    } deriving (Show)

-- notas de um aluno em uma disciplina específica
data NotasAluno = NotasAluno
    { disciplina :: Disciplina  -- referência à configuração da disciplina
    , provas     :: [Prova]     -- provas realizadas pelo aluno
    , provaFinal :: ProvaFinal  -- situação do aluno na prova final
    } deriving (Show)

data Aluno = Aluno
    { nomeAluno :: String
    , notas     :: [NotasAluno] -- notas do aluno em cada disciplina
    } deriving (Show)

-- estado global da aplicação: disciplinas da turma + lista de alunos
type Turma = ([Disciplina], [Aluno])







-- funções auxiliares

mediaPonderada :: [Prova] -> Double --recebe uma lista de provas e calcula a média ponderada
mediaPonderada provas = sum (map (\p -> valorNota p * pesoNota p) provas)

aprovadoDireto :: NotasAluno -> Bool
aprovadoDireto n = mediaPonderada (provas n) >= mediaAprovacao (disciplina n)
{-
    recebe as notas do aluno em uma disciplina,
    calcula a média ponderada das provas,
    e compara com a média mínima de aprovação da disciplina
-}

notaNecessaria :: NotasAluno -> Double
-- só faz sentido chamar se o aluno não for aprovado direto; verificar antes de usar
notaNecessaria n = (mediaAprovacao (disciplina n) - mediaPonderada (provas n) * pesoMediaFinal (disciplina n)) / pesoProvaFinal (disciplina n)
{-
    recebe as notas do aluno em uma disciplina,
    calcula qual nota ele precisaria tirar na prova final para ser aprovado,
    levando em conta os pesos da média regular e da prova final
-}

mediaLista :: [Double] -> Double
mediaLista lista = sum lista / fromIntegral (length lista)

mediaAluno :: Aluno -> Double
mediaAluno aluno
    | null (notas aluno) = 0.0
    | otherwise = mediaLista (map (\n -> mediaPonderada (provas n)) (notas aluno))
{-
    recebe um Aluno, extrai sua lista de NotasAluno,
    calcula a mediaPonderada das provas de cada disciplina,
    e tira a média dessas médias com mediaLista.
    se o aluno não tiver disciplinas cadastradas, retorna 0.0
-}

mediaGeralNotas :: [Aluno] -> Double
mediaGeralNotas alunos = mediaLista (map mediaAluno alunos)
{-
    recebe a lista de alunos,
    calcula a média individual de cada aluno com mediaAluno,
    e tira a média geral com mediaLista
-}


disciplinaAprovada :: NotasAluno -> Bool -- verifica se o aluno foi aprovado em uma disciplina, considerando os três casos de ProvaFinal
disciplinaAprovada n = case provaFinal n of
    SemFinal   -> aprovadoDireto n
    Pendente   -> False
    Feita nota -> (mediaPonderada (provas n) * pesoMediaFinal (disciplina n))
               +  (nota              * pesoProvaFinal (disciplina n))
               >= mediaAprovacao (disciplina n)
{-
    SemFinal: aprovado direto pela média regular
    Pendente: ainda não fez a final, considerado reprovado
    Feita:    calcula a nota final ponderada e compara com a mínima
-}

alunoAprovado :: Aluno -> Bool
-- retorna True se o aluno está aprovado em todas as suas disciplinas
alunoAprovado aluno = all disciplinaAprovada (notas aluno)









-- funcionalidades

-- ✅ média ponderada configurável por disciplina

-- ✅Calcular Ranking de notas

-- ✅Calcular Porcentagem de Aprovação

-- ✅Calcular e mostrar maior média

-- ✅Calcular média geral das notas

-- ✅Calcular nota necessária na final

-- ✅Calcular a disciplina mais difícil


maiorMedia :: [Aluno] -> IO ()
maiorMedia alunos = do
    let alunoMaior = maximumBy (\a b -> compare (mediaAluno a) (mediaAluno b)) alunos
    putStrLn ("Aluno destaque: " ++ nomeAluno alunoMaior ++ " | média: " ++ show (mediaAluno alunoMaior))
{-
    recebe a lista de alunos,
    encontra o de maior média com maximumBy,
    e exibe o nome e a média
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
                                               then a { disciplinas = disciplinas a ++ [(novaDisc, SemFinal)] }
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
{-
    recebe a lista de alunos,
    filtra os aprovados em todas as disciplinas com alunoAprovado,
    calcula a porcentagem e exibe o resultado
-}




disciplinaMaisDificil :: Alunos -> IO() 
disciplinaMaisDificil alunos = do
    let todasDisciplinas = concatMap (map fst . disciplinas) alunos
    if null todasDisciplinas
        then putStrLn "Nenhuma disciplina cadastrada!"
        else do
            let maisDificil = minimumBy (\a b -> compare (mediaPonderada (provas a)) (mediaPonderada (provas b))) todasDisciplinas
            putStrLn ("Disciplina mais difícil: " ++ nomeDisciplina maisDificil)
{-
    recebe a lista de alunos,
    junta todas as disciplinas em uma lista só com concatMap,
    se não houver disciplinas cadastradas, avisa o usuário,
    caso contrário compara as médias ponderadas com minimumBy,
    e exibe a disciplina com a menor média
-}



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
                        SemFinal -> putStrLn "Aluno aprovado direto"
                        Feita _  -> putStrLn "Aluno já fez a final"
                        Pendente -> putStrLn ("Nota necessária na final: " ++ show (notaNecessaria disc))
{-
    recebe a lista de alunos,
    pede o nome do aluno e da disciplina,
    verifica se existem na lista,
    e exibe a situação do aluno na disciplina ou a nota necessária na final
-}










-- Main

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
    | toUpper letra == 'P' = porcentagemAprovacao alunos >> loop alunos                           
    | toUpper letra == 'F' = mostrarNotaNecessaria alunos >> loop alunos
    | toUpper letra == 'D' = disciplinaMaisDificil alunos >> loop alunos
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
    _ <- getLine
    escolha letra alunos

main :: IO()
main = loop []
