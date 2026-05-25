# 📈 Análise de Séries Temporais: Despesas Governamentais (SARIMA e Detecção de Outliers)

Este diretório contém o relatório técnico oficial e as visualizações gráficas referentes à Segunda Prova Prática da disciplina de **Análise de Séries Temporais** da Universidade Federal do Ceará (UFC), sob orientação da Prof. Drª Jeniffer Johana Duarte Sanchez.

Neste projeto, a metodologia de Box-Jenkins foi levada a um nível mais avançado, incorporando estabilização de variância, dupla diferenciação e a identificação formal de dados atípicos (outliers) em séries macroeconômicas.

---

## 🎯 Objetivos do Estudo

A análise teve como foco a modelagem estocástica e a previsão de uma série temporal referente às **despesas governamentais**. Os principais objetivos foram:
1. Avaliar a não-estacionariedade da série original (tanto na média quanto na variância).
2. Aplicar transformações matemáticas para estabilizar a série antes da modelagem.
3. Ajustar um modelo sazonal robusto (SARIMA) capaz de explicar a dinâmica complexa dos gastos.
4. Investigar a presença de choques estruturais (Outliers Aditivos e Inovativos) que pudessem distorcer as estimativas.

---

## 🛠️ Metodologia e Destaques Analíticos

A rotina estatística (desenvolvida em R) exigiu um tratamento de dados rigoroso, destacando-se as seguintes etapas metodológicas:

* **Transformações de Estacionariedade:** * Aplicação da **Transformação Logarítmica** ($\log(Z_t)$) para estabilizar a variância explosiva.
  * Uso de **Diferenciação Simples e Sazonal** ($(1-B)(1-B^{12})$) para remover tendências e padrões cíclicos anuais.
* **Detecção de Dados Atípicos:** Utilização de rotinas algorítmicas (como as funções `detectAO` e `detectIO`) para rastrear anomalias residuais. O estudo identificou com sucesso um **Outlier Inovativo (IO)** significativo em dezembro de 1994, indicando um choque sistêmico com efeitos persistentes na série.
* **Modelagem Final:** O modelo selecionado como ótimo após diagnóstico de resíduos e parcimônia foi o **`SARIMA(1,1,4)(0,1,1)[12]`**, contendo parâmetros auto-regressivos, de médias móveis e sazonais altamente significativos.

---

## 📂 Estrutura do Diretório

```text
├── graphics/
│   └── [Imagens e Gráficos exportados do R (ACF, PACF, Resíduos)]
├── Séries_Temporais_Prova_Prática_2.pdf      # Relatório Técnico Completo (LaTeX)
└── README.md                                 # Este documento