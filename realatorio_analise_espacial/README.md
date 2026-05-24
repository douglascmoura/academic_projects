# 🗺️ Análise Espacial: Índice de Progresso Social no Brasil (2024-2025)

Este subprojeto contém o relatório e os scripts de análise espacial desenvolvidos para a disciplina de **Introdução à Análise Espacial** (Centro de Ciências, Universidade Federal do Ceará). 

O estudo investiga a dinâmica e a distribuição do **Índice de Progresso Social (IPS)** em nível municipal e estadual no Brasil, mapeando desigualdades regionais e identificando a evolução socioterritorial entre 2024 e 2025.

---

## 🎯 Objetivos da Análise

O IPS é uma métrica que complementa indicadores puramente econômicos, avaliando Necessidades Humanas Básicas, Fundamentos de Bem-Estar e Oportunidades. Esta análise buscou:
1. Mapear espacialmente a distribuição do IPS nos mais de 5.500 municípios brasileiros.
2. Identificar agrupamentos e extremos regionais (outliers superiores e inferiores) por meio de **Boxmaps**.
3. Realizar uma análise comparativa de dispersão (Quadrantes Alto-Alto, Baixo-Baixo) entre 2024 e 2025, com destaque específico para os municípios do estado do **Ceará**.

---

## 🛠️ Tecnologias e Pacotes Utilizados (R)

A rotina computacional foi inteiramente desenvolvida no R, focando em análise de dados espaciais (GIS) e visualização de dados:

* **Geoprocessamento:** `sf`, `geobr` (malhas municipais e estaduais do IBGE).
* **Tratamento e Visualização:** `ggplot2`, `dplyr`, `tidyr`, `RColorBrewer`.
* **Estatística Descritiva:** `psych`.
* **Documentação:** Relatório técnico construído e formatado no ecossistema LaTeX.

---

## 📊 Destaques Metodológicos

- **Construção de Boxmaps:** Implementação de funções customizadas no R para categorizar e plotar o IPS municipal com base nos quartis e outliers (via método de Tukey). Isso gerou mapas coropléticos precisos que evidenciam o forte padrão de dependência espacial global no Brasil (concentração de altos índices no Sul/Sudeste/Centro-Oeste e desafios crônicos no Norte/Nordeste).
- **Análise de Transição (Gráficos de Dispersão):** Utilização de modelagem linear simples e divisão por eixos de média para visualizar municípios que sofreram choques regionais positivos ou negativos na transição de 2024 para 2025.
- **Top 10 Variações:** Geração de *rankings* visuais de barras identificando os polos de maior aceleração social no período e os territórios de atenção crítica.

---

## 🚀 Como Visualizar os Resultados

Todo o embasamento teórico, a metodologia de construção dos Boxmaps e a discussão detalhada sobre a dinâmica socioespacial dos municípios brasileiros podem ser lidos diretamente no relatório técnico abaixo.

👉 **[Clique aqui para ler o Relatório Técnico Completo (PDF)](./Análise_Espacial_IPS.pdf)**

---

## 📂 Estrutura da Pasta

```text
├── datasets/
│   ├── IPSBrasil2024.xlsx                # Dados e Microdados municipais do IPS 2024
│   └── IPSBrasil2025.xlsx                # Dados e Microdados municipais do IPS 2025
├── scripts/
│   └── ips_brasil_24_25.R                # Rotina R (EDA, Mapas e Dispersão)
├── Análise_Espacial_IPS.pdf
└── README.md                             