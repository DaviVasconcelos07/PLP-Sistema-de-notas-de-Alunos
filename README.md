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
│   └── Módulos padrão do Haskell (Data.List, Data.Ord, etc.)
│
├── 2. TIPOS DE DADOS
│   └── Definição das estruturas: Aluno, Disciplina, NotaAluno, ProvaConfig
│
├── 3. FUNÇÕES AUXILIARES / HELPERS
│   └── Funções puras reutilizáveis de baixo nível
│       (ex: somaComPesos, aprovado, zipComPeso)
│
├── 4. CÁLCULOS CORE
│   └── Funções base das quais todas as features dependem
│       (ex: calcularMediaPonderada, mediaAluno)
│
├── 5. FUNCIONALIDADES (F1–F8)
│   └── Uma função por feature listada na tabela acima
│
├── 6. EXIBIÇÃO / FORMATAÇÃO
│   └── Funções responsáveis por formatar a saída para o terminal
│       — separa a lógica de apresentação da lógica de negócio
│
├── 7. DADOS DE TESTE
│   └── Turma fictícia hardcoded para demonstração
│       (alunos, disciplinas e notas pré-definidos)
│
└── 8. MAIN / I/O
    └── Menu interativo em CLI para navegar pelas funcionalidades
```

## Como Executar

### Pré-requisitos

- [GHC](https://www.haskell.org/ghc/) (Glasgow Haskell Compiler) instalado

### Compilar e executar

```bash
# Compilar
ghc Main.hs -o sistema-notas

# Executar
./sistema-notas
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
- **Funções de ordem superior** — uso de `map`, `filter`, `foldr`, `sortBy`, `groupBy`, entre outras
- **Separação IO / lógica pura** — o `main` age apenas como um conector fino entre a entrada do usuário e as funções puras, respeitando a fronteira imposta pelo tipo `IO` do Haskell

---

## Autores
- Davi de Lucena Vasconcelos
- Antonio Farias Lopes Neto
- Carlos Alberto Leal Do Nascimento
- 
- 
- 

Desenvolvido como projeto acadêmico para a disciplina de Paradigmas de Linguagem de Programação.
