# 🎓 Portfólio Acadêmico: Estatística & Ciência de Dados

Bem-vindo ao meu repositório central de projetos acadêmicos! 

Este espaço é dedicado a consolidar os relatórios técnicos, modelagens estatísticas, rotinas de código e apresentações desenvolvidos ao longo da minha trajetória na graduação em **Estatística** pela Universidade Federal do Ceará (UFC). 

O foco deste repositório é demonstrar a aplicação de metodologias estatísticas rigorosas a dados reais, unindo fundamentação matemática, programação e *Data Storytelling*.

---

## 🗂️ Diretório de Projetos

Os trabalhos estão divididos em subpastas temáticas de acordo com suas respectivas disciplinas e áreas de estudo. Cada pasta contém seu próprio `README.md` com explicações detalhadas, os *datasets* utilizados, os *scripts* em R e o relatório técnico em PDF formatado em LaTeX.

### 📈 Séries Temporais (Time Series Analysis)
Projetos focados em modelagem estocástica, decomposição de sinal e previsão (*forecast*) de eventos macroeconômicos e ambientais.
* **[`series_temporais_prova_pratica_1/`](./series_temporais_prova_pratica_1/)**: Aplicação base da metodologia Box-Jenkins em dados de consumo pessoal.
* **[`series_temporais_prova_pratica_2/`](./series_temporais_prova_pratica_2/)**: Identificação e modelagem de **Outliers** (Inovativos e Aditivos) em séries de despesas governamentais.
* **[`series_temporais_atividade_pratica/`](./series_temporais_atividade_pratica/)**: Tratamento de sazonalidade forte e projeções para os níveis de ozônio.


### 🗺️ Análise Espacial (Spatial Statistics)
Projetos de geoprocessamento focados na identificação de padrões espaciais, clusters e desigualdades territoriais.
* **[`relatorio_analise_espacial/`](./relatorio_analise_espacial/)**: Análise do Índice de Progresso Social (IPS) dos mais de 5.500 municípios do Brasil (2024 vs. 2025). Geração de **Boxmaps** coropléticos e identificação de outliers socioterritoriais.
* **[`atividade_analise_espacial/`](./atividade_analise_espacial/)**: Apresentação executiva (*Data Storytelling*) sobre o perfil sociodemográfico e educacional do estado do Ceará ao longo da última década.

### 📊 Dados Longitudinais (Longitudinal Data)
Estudos avançados em modelagem de dados com medidas repetidas no tempo, focados em dependência intra-unidade.
* **[`atividade_dados_longitudinais/`](./atividade_dados_longitudinais/)**: Ajuste de **Modelos Lineares Mistos (LMM)** para estudos pré/pós-teste e modelagem de crescimento com estruturas de covariância heterocedásticas. O grande diferencial deste projeto é a implementação de um **módulo customizado de diagnóstico avançado** (Distância de Mahalanobis, Índice de Lesaffre-Verbeke).

---

## 🛠️ Tecnologias e Ferramentas

O ferramental técnico utilizado ao longo destes projetos reflete o padrão de mercado para pesquisa e análise avançada de dados:

* **Linguagens:** `R`
* **Geoprocessamento:** `sf`, `geobr`
* **Séries Temporais:** `forecast`, `fpp2`, `tseries`
* **Modelagem Longitudinal:** `nlme`, `lme4`
* **Visualização:** `ggplot2`, `GGally`
* **Documentação Científica:** `LaTeX`, `Markdown`

---

## 🚀 Como Navegar

Sinta-se à vontade para explorar as pastas! Para a melhor experiência:
1. Acesse a pasta do projeto que mais lhe interessar.
2. Leia o `README.md` local para entender o contexto do problema.
3. Abra os arquivos `.pdf` para ver o rigor matemático e as análises aprofundadas.
4. Verifique a pasta `script/` para auditar a lógica de programação utilizada.

---
--- *Desenvolvido por **Douglas Chaves Moura**.*