# Análise de Dados Longitudinais: Efeito de Solução para Bochecho no Potencial Cariogênico

Este repositório contém os códigos em R e a apresentação final referentes à atividade da disciplina de **Análise de Dados Longitudinais** (CC0300), ministrada no Departamento de Estatística e Matemática Aplicada da Universidade Federal do Ceará (UFC). O estudo foi desenvolvido sob a orientação do **Prof. Dr. Juvêncio Santos Nobre**.

## 📄 Resumo do Projeto
Um dos principais fatores que contribuem para o desenvolvimento da cárie é a diminuição do pH na cavidade bucal, especialmente quando este se torna inferior a 5,5. Quando o pH oral cai abaixo desse valor crítico, ocorre a desmineralização do esmalte dental, favorecendo a ação das bactérias cariogênicas e aumentando o risco de formação de lesões de cárie.

O objetivo desta análise foi avaliar o efeito do uso contínuo de uma solução para bochecho no pH da placa bacteriana dentária, baseando-se em dados provenientes de um estudo realizado na Faculdade de Odontologia da Universidade de São Paulo.

## 📊 Metodologia e Base de Dados
Foi avaliada uma amostra de 21 voluntários, medindo-se o pH antes e depois da intervenção. Para a análise de dados emparelhados, utilizamos:
- **Estatística Descritiva e Visualização:** Avaliação das variáveis através de boxplots, histogramas e gráficos de dispersão.
- **Teste t Pareado:** Utilizado para comparar as médias das duas amostras relacionadas e testar a hipótese nula de que não há diferença significativa entre as médias antes e depois do uso da solução.
- **Suposição de Normalidade:** A normalidade das diferenças foi verificada graficamente e corroborada pelo teste de Shapiro-Wilk, resultando em um valor-_p_ de 0,2992, atestando o cumprimento da premissa para o uso do teste t.

## 🛠️ Tecnologias e Pacotes Utilizados
- **R:** Manipulação de dados (`dplyr`, `tidyr`), análise exploratória (`psych`) e visualizações de alto nível (`ggplot2`, `gridExtra`).
- **Documentação Científica:** LaTeX e RMarkdown.

## 🚀 Principais Resultados
- A diferença (Antes - Depois) demonstrou uma variação média de -3,95 na amostra estudada.
- O teste t pareado evidenciou um valor-_p_ de 0,01992. Como o valor-_p_ é inferior ao nível de significância de 5%, rejeitamos a hipótese nula e concluímos que há uma diferença estatisticamente significativa no potencial cariogênico após o uso do bochecho.
- O intervalo de confiança de 95% para a diferença média entre os dois grupos foi de (-7,21; -0,69). Esse intervalo estritamente negativo reforça que a solução resultou em uma redução do potencial cariogênico.
- **Conclusão Geral:** O uso da solução de bochecho promove um aumento no valor do pH oral, evidenciando uma melhora na defesa contra bactérias cariogênicas e sugerindo eficácia na prevenção de cáries.

---

👉 **[Clique aqui para visualizar a Apresentação Completa (PDF)](./Atividade_de_Longitudinal.pdf)**C:\Users\dougl\OneDrive\Pastas\Git&GitHub\academic-projects\atividade_dados_longitudinais\
(Dados Longitudinais - Efeito do Bochecho no Potencial Cariogênico.pdf)