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

adicionarAluno :: Turma -> IO Turma
adicionarAluno (discs, alunos) = do
    putStrLn "\nNome do aluno:"
    nome <- getLine
    let notasIniciais = map (\d -> NotasAluno { disciplina = d, provas = [], provaFinal = SemFinal }) discs
    let novoAluno     = Aluno { nomeAluno = nome, notas = notasIniciais }
    return (discs, alunos ++ [novoAluno])
{-
    pede o nome do aluno,
    cria um NotasAluno vazio para cada disciplina já cadastrada na turma,
    e adiciona o aluno à lista
-}

adicionarDisciplina :: Turma -> IO Turma
adicionarDisciplina (discs, alunos) = do
    putStrLn "\nNome da disciplina:"
    nomeDisc <- getLine
    putStrLn "Média de aprovação:"
    media <- readLn
    putStrLn "Peso da média regular:"
    pesoMF <- readLn
    putStrLn "Peso da prova final:"
    pesoPF <- readLn
    let novaDisc  = Disciplina { nomeDisciplina = nomeDisc, pesoMediaFinal = pesoMF, pesoProvaFinal = pesoPF, mediaAprovacao = media }
    let notaVazia = NotasAluno  { disciplina = novaDisc, provas = [], provaFinal = SemFinal }
    let alunosAtualizados = map (\a -> a { notas = notas a ++ [notaVazia] }) alunos
    return (discs ++ [novaDisc], alunosAtualizados)
{-
    pede a configuração da disciplina (nome, pesos, média mínima),
    adiciona a disciplina à lista da turma,
    e cria um NotasAluno vazio (sem provas, SemFinal) para cada aluno já cadastrado
-}


mostrarMediaGeral :: [Aluno] -> IO ()
mostrarMediaGeral alunos = do
    putStrLn ("Média geral da turma: " ++ show (mediaGeralNotas alunos))
{-
    recebe a lista de alunos,
    calcula a média geral das notas com mediaGeralNotas,
    e exibe o resultado na tela
-}


ranking :: [Aluno] -> IO ()
ranking alunos = do
    let ordenados = sortBy (\a b -> compare (mediaAluno b) (mediaAluno a)) alunos
    mapM_ (\a -> putStrLn (nomeAluno a ++ " - " ++ show (mediaAluno a))) ordenados
{-
    recebe a lista de alunos,
    ordena da maior média para a menor com sortBy,
    e exibe o ranking na tela
-}


porcentagemAprovacao :: [Aluno] -> IO ()
-- calcula e exibe a porcentagem de alunos aprovados em todas as disciplinas
porcentagemAprovacao alunos = do
    let aprovados   = length (filter alunoAprovado alunos)
    let total       = length alunos
    let porcentagem = fromIntegral aprovados / fromIntegral total * 100 :: Double
    putStrLn ("Aprovados: " ++ show porcentagem ++ "%")
{-
    filtra os alunos aprovados em todas as disciplinas com alunoAprovado,
    calcula a porcentagem sobre o total e exibe o resultado
-}




disciplinaMaisDificil :: [Aluno] -> IO ()
disciplinaMaisDificil alunos = do
    let todasNotas = concatMap notas alunos
    if null todasNotas
        then putStrLn "Nenhuma disciplina cadastrada!"
        else do
            let maisDificil = minimumBy (\a b -> compare (mediaPonderada (provas a)) (mediaPonderada (provas b))) todasNotas
            putStrLn ("Disciplina mais difícil: " ++ nomeDisciplina (disciplina maisDificil))
{-
    coleta todos os NotasAluno de todos os alunos com concatMap,
    encontra o de menor média ponderada com minimumBy,
    e exibe o nome da disciplina correspondente
-}



mostrarNotaNecessaria :: [Aluno] -> IO ()
-- pede nome do aluno e da disciplina; exibe a situação ou a nota necessária na final
mostrarNotaNecessaria alunos = do
    putStrLn "\nNome do aluno:"
    nome <- getLine
    let alunoEncontrado = filter (\a -> nomeAluno a == nome) alunos
    if null alunoEncontrado
        then putStrLn "Aluno não encontrado!"
        else do
            let aluno = head alunoEncontrado
            putStrLn "Nome da disciplina:"
            nomeDisc <- getLine
            let notasEncontradas = filter (\n -> nomeDisciplina (disciplina n) == nomeDisc) (notas aluno)
            if null notasEncontradas
                then putStrLn "Disciplina não encontrada!"
                else do
                    let n = head notasEncontradas
                    case provaFinal n of
                        SemFinal -> putStrLn "Aluno aprovado direto"
                        Feita _  -> putStrLn "Aluno já fez a final"
                        Pendente -> putStrLn ("Nota necessária na final: " ++ show (notaNecessaria n))
{-
    pede o nome do aluno e da disciplina,
    verifica se existem na lista,
    e exibe a situação do aluno na disciplina ou a nota necessária na final
-}










-- Main

escolha :: Char -> Turma -> IO ()
escolha letra turma@(_, alunos)
    | toUpper letra == 'A' = do
        turmaAtualizada <- adicionarAluno turma
        loop turmaAtualizada
    | toUpper letra == 'I' = do
        turmaAtualizada <- adicionarDisciplina turma
        loop turmaAtualizada
   -- | toUpper letra == 'E' = editarMateria >> loop turma
    | toUpper letra == 'M' = mostrarMediaGeral alunos >> loop turma
    | toUpper letra == 'T' = maiorMedia alunos        >> loop turma
    | toUpper letra == 'P' = porcentagemAprovacao alunos >> loop turma
    | toUpper letra == 'F' = mostrarNotaNecessaria alunos >> loop turma
    | toUpper letra == 'D' = disciplinaMaisDificil alunos >> loop turma
    | toUpper letra == 'R' = ranking alunos           >> loop turma
    | toUpper letra == 'S' = putStrLn "\nAté Mais!"
    | otherwise             = putStrLn "\nResposta Inválida" >> loop turma



-- main

loop :: Turma -> IO ()
loop turma = do

    putStrLn "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    putStrLn "         Sistema de Notas          "
    putStrLn "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    putStrLn "Selecione uma opção:\n"
    putStrLn ("Adicionar Aluno(A)\n\
        \Adicionar Disciplina(I)\n\
        \Media Geral das Notas(M)\n\
        \Maior Média(T)\n\
        \Porcentagem de Aprovação(P)\n\
        \Nota Necessaria na prova Final(F)\n\
        \Disciplina mais Difícil(D)\n\
        \Ranking de Notas(R)\n\
        \Sair(S)\n")
    letra <- getChar
    _ <- getLine
    escolha letra turma

main :: IO ()
main = loop ([], [])
