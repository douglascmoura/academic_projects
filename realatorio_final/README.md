# 📈 Análise de Dados Longitudinais: Modelos Mistos e Estruturas de Correlação

Este repositório consolida as análises e modelagens desenvolvidas para a disciplina de **Análise de Dados Longitudinais (CC0300)** da Universidade Federal do Ceará (UFC), orientada pelo **Prof. Dr. Juvêncio Santos Nobre**.

O foco deste projeto é a aplicação prática de Modelos Lineares Mistos (LMM) e técnicas avançadas de diagnóstico para lidar com dependência temporal, correlação intraunidade e heterocedasticidade em dados de medidas repetidas.

---

## 🛠️ Tecnologias e Pacotes Utilizados

- **Linguagem:** R
- **Modelagem Estatística:** `nlme`, `lme4`
- **Visualização e Manipulação:** `ggplot2`, `dplyr`, `tidyr`, `GGally`
- **Documentação Científica:** LaTeX (Relatório PDF)

---

## 📂 Estudos Realizados

Este repositório é composto por dois estudos aplicados distintos, cujos códigos e o relatório metodológico completo estão disponíveis nas pastas.

### Estudo 1: Avaliação de Tratamento Pré e Pós-Teste (PAM)
Análise do efeito do sulfato de magnésio ($MgSO_4$) na Pressão Arterial Média (PAM) de cães previamente tratados com indometacina ou nifedipina.
* **Metodologia:** Análise exploratória por perfis médios com IC assintótico e ajuste de um **Modelo Linear Misto (LMM)** considerando interações entre tratamento (Grupo) e evolução temporal (Tempo).
* **Achados:** Redução estatisticamente significativa e consistente da PAM em ambos os grupos pós-intervenção, com alta variabilidade explicada pelas diferenças fisiológicas individuais (efeito aleatório $b_j$).

### Estudo 2: Modelagem de Crescimento e Heterocedasticidade (`pig.weights`)
Modelagem longitudinal da trajetória de ganho de peso de 48 suínos medidos semanalmente durante 9 semanas. 
* **Metodologia:** Como o variograma indicou dependência espacial forte no tempo e heterocedasticidade, a modelagem via pacote `nlme` contrastou múltiplos modelos:
  - Modelo Linear Simples (MLS)
  - Modelo Linear Misto Heteroscedástico (MLMH)
  - **ARH(1):** Modelo Autoregressivo Heteroscedástico de Primeira Ordem.
  - **ARp(1):** Autoregressivo com Heterocedasticidade Potência.
* **Diagnósticos de Alta Complexidade:** Implementação de rotinas de avaliação de ajuste e alavancagem, incluindo Distância Condicional de Cook, Distância de Mahalanobis para BLUPs e Índice Modificado de Lesaffre-Verbeke para identificação e tratamento de outliers longitudinais.

---

## 🚀 Como Visualizar os Resultados

Todo o embasamento teórico, as matrizes de covariância utilizadas e a discussão estatística detalhada de cada modelo podem ser lidos diretamente no relatório técnico abaixo.

👉 **[Clique aqui para ler o Relatório Técnico Completo (PDF)](./Relatório_Dados_Longitudinais.pdf)**

## 📁 Organização do Repositório

```text
├── dados/
│   ├── Singer&Nobre&Rocha2017exemp531.xls  # Base de dados (Estudo 1)
│   └── pig_weights.xlsx                     # Base de dados (Estudo 2)
├── scripts/
│   ├── script_pam.R                        # Código de modelagem para o Estudo 1
│   └── script_suinos.R                     # Código de modelagem para o Estudo 2
├── Relatório_Dados_Longitudinais.pdf
└── README.md
```