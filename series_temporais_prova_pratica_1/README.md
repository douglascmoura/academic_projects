# 📈 Análise de Séries Temporais: Variação dos Gastos de Consumo Pessoal

Este diretório contém o relatório técnico, os gráficos e o script de modelagem referentes à primeira avaliação prática da disciplina de **Análise de Séries Temporais** da Universidade Federal do Ceará (UFC), ministrada pela Prof. Drª Jeniffer Johana Duarte Sanchez.

O projeto documenta um roteiro completo de análise estocástica, aplicando a clássica **Metodologia de Box-Jenkins** (Identificação, Estimação e Diagnóstico) em dados macroeconômicos.

---

## 🎯 Objetivos da Análise

O estudo teve como premissa identificar a estrutura estocástica de uma série temporal que mede a **variação percentual trimestral dos gastos de consumo pessoal** entre o período de 1970 a 2016 (187 observações). Os principais objetivos foram:
1. Analisar a estacionariedade, tendência e sazonalidade da série via testes formais.
2. Identificar os parâmetros $p$, $d$ e $q$ observando os decaimentos das funções de autocorrelação (ACF) e autocorrelação parcial (PACF).
3. Estimar múltiplos modelos preditivos da classe **ARIMA**.
4. Realizar uma rigorosa análise de diagnóstico residual, ponderando sobre parcimônia e métricas de acurácia preditiva.

---

## 🛠️ Metodologia e Modelagem (Box-Jenkins)

Todo o pipeline analítico foi construído na linguagem **R** (com auxílio dos pacotes `forecast`, `fpp2`, `tseries` e `ggplot2`). A modelagem englobou:

* **Testes Formais:** Aplicação dos testes de Dickey-Fuller Aumentado (ADF) e KPSS (Estacionariedade), Mann-Kendall e Regressão Linear (Tendência) e Quadratic Spectral (Sazonalidade).
* **Modelos Propostos:** A partir dos limites marginais dos correlogramas, foram ajustados os modelos:
  * **AR(3)** - ARIMA(3,0,0)
  * **MA(3)** - ARIMA(0,0,3)
  * **ARMA(3,3)** - ARIMA(3,0,3)
* **Critérios de Diagnóstico:** Testes de Ljung-Box (dependência serial), Shapiro-Wilk e Jarque-Bera (normalidade), além da inspeção visual via Q-Q plots e ACF dos resíduos.
* **Seleção de Modelo:** Contraste fundamentado nos critérios de informação de Akaike (AIC) e Schwarz (BIC), além de medidas de erro (RMSE e MAPE).

---

## 🚀 Principais Resultados

* **Comportamento da Série:** A série demonstrou ser fracamente estacionária, sem características fortes de sazonalidade, mas com uma leve tendência de queda ao longo das décadas e presença de outliers associados a choques trimestrais em anos passados.
* **Diagnóstico Residual:** Todos os modelos conseguiram capturar a dependência serial com eficácia (Ljung-Box não significativo). No entanto, a presença de caudas pesadas (leptocurtose) resultou em violações na suposição de normalidade dos resíduos.
* **Escolha do Modelo:** O modelo **ARIMA(3,0,0)** revelou-se a alternativa mais aderente ao princípio da parcimônia (menor número de parâmetros e menor AIC). Para um foco puramente focado em minimização de erros de previsão (MAPE, RMSE), o **ARMA(3,3)** obteve ligeira vantagem estatística.

---

## 🚀 Como Visualizar os Resultados

Para acessar toda a fundamentação teórica, a evolução matemática das Equações de Diferenças utilizadas nos modelos Auto-Regressivos, e as conclusões formatadas, acesse o documento oficial abaixo:

👉 **[Clique aqui para ver o Relatório Técnico Completo (PDF)](./Séries_Temporais_Prova_Prática_1.pdf)**

---

## 📂 Estrutura do Repositório

```text
├── dataset/
│   └── consumo.xls                          # Dataset (Série temporal trimestral)
├── graphics/
│   └── [Arquivos PDF com os plots do R]      # Funções de Autocorrelação e Diagnósticos
├── script/
│   └── script_series_temporais.R             # Código fonte da análise estatística
├── Séries_Temporais_Prova_Prática_1.pdf      # Relatório Técnico Oficial
└── README.md                                 # Este documento