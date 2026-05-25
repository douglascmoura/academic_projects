# 🌤️ Análise de Séries Temporais: Níveis de Ozônio (Modelagem SARIMA)

Este diretório contém o relatório técnico e o script de modelagem referentes à segunda atividade prática da disciplina de **Análise de Séries Temporais** do curso de Estatística da Universidade Federal do Ceará (UFC), ministrada pela Prof. Drª Jeniffer Johana Duarte Sanchez.

O projeto documenta a análise de uma série com forte componente sazonal, aplicando a metodologia de Box-Jenkins para o ajuste de modelos **SARIMA (Seasonal Autoregressive Integrated Moving Average)** e geração de previsões.

---

## 🎯 Objetivos da Análise

O estudo teve como premissa analisar os **níveis mensais de ozônio** registrados no período de 1956 a 1970. Os principais objetivos foram:
1. Realizar a decomposição da série para isolar o forte comportamento sazonal presente nos dados.
2. Identificar a estrutura estocástica por meio das funções de autocorrelação (ACF) e autocorrelação parcial (PACF).
3. Ajustar e diagnosticar modelos sazonais (SARIMA) adequados à dinâmica multiplicativa/aditiva do fenômeno ambiental.
4. Projetar (forecast) os níveis de ozônio para os **12 meses subsequentes**, fornecendo intervalos de confiança (PI).

---

## 🛠️ Metodologia e Modelagem

Todo o processamento analítico foi desenvolvido na linguagem **R** (com destaque para o ecossistema `fpp2` e `forecast`). O fluxo estatístico englobou:

* **Análise Exploratória Sazonal:** Aplicação de decomposição multiplicativa e boxplots mensais para evidenciar os picos cíclicos de concentração de ozônio.
* **Diagnóstico Residual:** * Avaliação de independência (Teste de Ljung-Box iterativo para múltiplos *lags*).
  * Teste de Normalidade (Shapiro-Wilk) e inspeção via Q-Q Plot.
  * Validação de ruído branco por meio da função `checkresiduals()`.
* **Previsão:** Geração do *forecast* com representação visual avançada via `ggplot2`, sobrepondo a série original, a projeção do modelo e as bandas de incerteza (80% e 95%).

---

## 📂 Estrutura do Repositório

```text
├── dataset/
│   └── OZONIO.XLS                            # Base de dados (Série Mensal 1956-1970)
├── script/
│   └── script_ozonio.R                       # Código R com EDA, Diagnóstico e Previsões
├── Séries_Temporais_Atividade_Prática_2.pdf  # Relatório Técnico Oficial
└── README.md                                 # Este documento