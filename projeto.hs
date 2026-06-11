--imports
import Data.Char (toUpper)







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

mediaGeralNotas :: [Aluno] -> Double
mediaGeralNotas alunos =
    mediaLista (map mediaAluno alunos)
{-
    recebe uma lista de Alunos,
    calcula a média de cada aluno usando mediaAluno,
    monta uma lista com essas médias,
    e o caba tira a média geral com mediaLista
-}


maiorMedia :: [Aluno] -> Double
maiorMedia alunos =
    maximum (map mediaAluno alunos)
{-
    recebe uma lista de Alunos,
    calcula a média de cada um com mediaAluno,
    monta uma lista dessas médias,
    e retorna a maior delas com maximum
-}



-- funcionalidades

-- média ponderada configurável por disciplina

-- Calcular Ranking de notas

-- Calcular Porcentagem de Aprovação

-- Calcular e mostrar maior média

-- Calcular média geral das notas

-- Calcular nota necessária na final

-- Calcular a disciplina mais difícil


escolha :: Char -> IO()
escolha letra
   -- | toUpper letra == 'A' = adicionarMateria >> main
   -- | toUpper letra == 'E' = editarMateria >> main
   -- | toUpper letra == 'M' = mediaGeral >> main
   -- | toUpper letra == 'T' = maiorMedia >> main
   -- | toUpper letra == 'P' = porcentagemAP >> main                            
   -- | toUpper letra == 'F' = notaNecessaria >> main
   -- | toUpper letra == 'D' = disMaisDificil >> main
   -- | toUpper letra == 'R' = ranking >> main
    | toUpper letra == 'S' = putStrLn "\nAté Mais!"
    | otherwise = putStrLn "\nResposta Inválida" >> main



-- main
main :: IO()
main = do
    putStrLn "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    putStrLn "         Sistema de Notas          "
    putStrLn "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    putStrLn "Selecione uma opção:\n"
    putStrLn ("Adicionar Matéria(A)\n\
             \Editar Matéria(E)\n\
             \Media Geral das Notas(M)\n\
             \Maior Média(T)\n\
             \Porcentagem de Aprovação(P)\n\
             \Nota Necessaria na prova Final(F)\n\
             \Disciplina mais Difícil(D)\n\
             \Ranking de Notas(R)\n\
             \Sair(S)\n")
    letra <- getChar
    escolha letra
