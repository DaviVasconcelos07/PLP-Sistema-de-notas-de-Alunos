--imports
import Data.Char (toUpper)




-- funções auxiliares




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
