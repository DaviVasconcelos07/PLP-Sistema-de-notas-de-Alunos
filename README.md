# Sistema de Notas de Alunos

## Funcionalidades

| ID | Funcionalidade | Descrição |
|----|----------------|-----------|
| 1 | **Média ponderada configurável por disciplina** | Cada disciplina possui um peso para cada nota. O professor pode definir quantidades diferentes de provas por disciplina. |
| 2 | **Calcular Ranking de notas** | Rankeia os alunos da maior para a menor média. |
| 3 | **Calcular Porcentagem de Aprovação** | Mostra em porcentagem a quantidade de alunos aprovados na turma. |
| 4 | **Calcular e mostrar maior média** | Identifica e exibe o aluno destaque, ou seja, o aluno com a maior média. |
| 6 | **Calcular média geral das notas** | Exibe a média geral calculada a partir das médias individuais de todos os alunos. |
| 7 | **Calcular nota necessária na final** | Simula a nota que um aluno precisa tirar na prova final para ser aprovado. |
| 8 | **Calcular a disciplina mais difícil** | Identifica e exibe a disciplina na qual os alunos apresentam mais dificuldades. |

---

## Estrutura do Projeto

```
Main.hs
│
├── 1. IMPORTS
│   └── Módulos padrão do Haskell (Data.Char, Data.List)
│
├── 2. TIPOS DE DADOS
│   └── Definição das estruturas: Aluno, Disciplina, Prova, ProvaFinal
│
├── 3. FUNÇÕES AUXILIARES
│   └── Funções puras reutilizáveis de baixo nível
│       (ex: mediaPonderada, mediaAluno, aprovadoDireto, alunoAprovado)
│
├── 4. FUNCIONALIDADES
│   └── Uma função por feature listada na tabela acima
│
└── 5. MAIN / I/O
    └── Menu interativo em CLI para navegar pelas funcionalidades
```

## Como Executar

### Pré-requisitos

- [GHC](https://www.haskell.org/ghc/) (Glasgow Haskell Compiler) instalado

### Compilar e executar

```bash
# Compilar
ghc Main.hs -o sistema-notas

# Executar no Linux/Mac
./sistema-notas

# Executar no Windows
sistema-notas.exe
```

### Ou executar diretamente com runghc

```bash
runghc Main.hs
```

---

## Paradigma Funcional

O projeto aplica os seguintes conceitos do paradigma funcional:

- **Funções puras** — toda a lógica de negócio (cálculos, rankings, simulações) é implementada sem efeitos colaterais
- **Imutabilidade** — nenhum dado é modificado; novas estruturas são derivadas a partir das existentes
- **Funções de ordem superior** — uso de `map`, `filter`, `sortBy`, `maximumBy`, `minimumBy`, entre outras
- **Separação IO / lógica pura** — o `main` age apenas como um conector fino entre a entrada do usuário e as funções puras, respeitando a fronteira imposta pelo tipo `IO` do Haskell

---

## Autores
- Davi de Lucena Vasconcelos
- Antonio Farias Lopes Neto
- Carlos Alberto Leal Do Nascimento
- João Victor Fernandes Martins
- 
- 

Desenvolvido como projeto acadêmico para a disciplina de Paradigmas de Linguagem de Programação.