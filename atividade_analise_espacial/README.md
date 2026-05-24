# 📊 Perfil Sociodemográfico e Evolução do Desenvolvimento Municipal no Ceará

Este diretório contém os dados e a apresentação final referentes à **Análise Espacial Exploratória** dos municípios do estado do Ceará. O projeto buscou compreender a fundo a dinâmica demográfica, socioeconômica e educacional do estado, mapeando a transição ocorrida na última década (com foco no período entre 2010 e 2022).

Este foi um trabalho colaborativo desenvolvido por **Douglas Chaves Moura**, Caio Bruno Lopes de Carvalho, Clayton Coelho Brito e Juan Silva Liziero.

---

## 🎯 Objetivos da Análise

A abordagem espacial deste estudo teve como premissa identificar e visualizar disparidades e concentrações geográficas no Ceará. O objetivo principal foi fornecer *insights* visuais claros sobre as transformações territoriais, auxiliando na compreensão de como diferentes características sociais se distribuem e evoluem no espaço.

---

## 🔍 Dimensões Analisadas

A investigação de geoprocessamento e análise exploratória foi dividida em quatro eixos centrais de avaliação socioeconômica e demográfica (baseados em dados do IBGE e índices estaduais):

1. **Evolução Racial (2010 vs. 2022):** Análise da forte transição da autodeclaração de raça/cor (Branca, Preta, Amarela, Parda, Indígena) na população cearense ao longo de 12 anos.
2. **Distribuição por Sexo:** Mapeamento espacial da razão de sexo e da distribuição demográfica entre homens e mulheres nos diferentes municípios cearenses.
3. **Tempo de Estudo:** Investigação do nível educacional da população, identificando polos de concentração acadêmica e áreas de vulnerabilidade histórica no estado.
4. **Índice de Desenvolvimento Municipal (IDM):** Avaliação de indicadores-chave (como o IDM Ambiental e Institucional) na janela de 2019 a 2022. Utilização de técnicas espaciais para mapear o "IDM da vizinhança", classificando os municípios em quantis e outliers territoriais.

---

## 🚀 Como Visualizar os Resultados

Existem duas versões da apresentação deste projeto: a versão original, com melhor qualidade visual, e uma versão comprimida, mais leve para download e compartilhamento.

👉 **[Clique aqui para ver a versão original](./Apresentação_Análise_Espacial.pdf)**

👉 **[Clique aqui para ver a versão comprimida](./Apresentação_Análise_Espacial_compressed.pdf)**


---

## 📂 Estrutura da Pasta

Como este é um subprojeto focado em **Data Storytelling** e comunicação visual estratégica, a estrutura consolida as bases brutas utilizadas e o documento final de apresentação:

```text
├── datasets/
│   ├── Censo População Raça              # Dados demográficos do Censo
│   ├── Censo População Sexo              # Dados de gênero do Censo
│   ├── Censo tempo de Estudos            # Dados educacionais
│   └── IDM Ceará                         # Microdados do Índice de Desenvolvimento
├── Apresentação_Análise_Espacial_compressed.pdf
├── Apresentação_Análise_Espacial.pdf
└── README.md                             