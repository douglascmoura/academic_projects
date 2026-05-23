# ==============================================================================
# Análise de Dados Longitudinais: Efeito do Bochecho no Potencial Cariogênico
# Autores: Douglas Moura & Mailane Silva
# ==============================================================================

# 1. Carregando Pacotes --------------------------------------------------------
library(psych)
library(ggplot2)
library(dplyr)
library(tidyr)
library(gridExtra)

# 2. Base de Dados -------------------------------------------------------------
# Criando o dataframe com os dados de 21 voluntários
dados <- data.frame(
  voluntario = 1:21,
  antes = c(6.00, 0.00, 0.00, 3.37, 0.00, 14.25, 0.00, 0.00, 0.00, 0.00, 
            0.37, 14.25, 0.00, 14.44, 0.00, 0.00, 0.00, 0.00, 0.00, 12.37, 0.00),
  depois = c(3.37, 1.50, 10.69, 8.44, 2.50, 5.25, 5.50, 0.37, 1.50, 16.50,
             0.00, 15.94, 5.25, 0.00, 12.25, 9.25, 9.00, 8.50, 9.00, 22.50, 0.75)
)

# Adicionando a coluna de diferença
dados <- dados %>%
  mutate(diferenca = antes - depois)

# Transformando os dados para formato longo (tidy) para o ggplot2
dados_long <- dados %>%
  pivot_longer(cols = c(antes, depois), 
               names_to = "Condicao", 
               values_to = "pH") %>%
  mutate(Condicao = factor(Condicao, levels = c("antes", "depois")))

# 3. Análise Descritiva --------------------------------------------------------
cat("\n--- Estatísticas Descritivas ---\n")
print(describe(dados[, c("antes", "depois", "diferenca")]))

# 4. Análise Gráfica -----------------------------------------------------------
# Definindo um tema global para padronizar os gráficos
tema_padrao <- theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# 4.1 Boxplot
g_boxplot <- ggplot(dados_long, aes(x = Condicao, y = pH, fill = Condicao)) +
  geom_boxplot(alpha = 0.8) +
  scale_fill_manual(values = c("skyblue", "orange")) +
  labs(title = "Boxplot: 'Antes' vs 'Depois'", x = "Condição", y = "pH") +
  tema_padrao +
  theme(legend.position = "none")

# 4.2 Histograma
g_hist <- ggplot(dados_long, aes(x = pH, fill = Condicao)) +
  geom_histogram(bins = 6, alpha = 0.7, color = "white") +
  scale_fill_manual(values = c("skyblue", "orange")) +
  facet_wrap(~Condicao, scales = "free_x") +
  labs(title = "Distribuição do pH", x = "pH", y = "Frequência") +
  tema_padrao +
  theme(legend.position = "none")

# 4.3 Gráfico de Barras da Diferença
g_barras <- ggplot(dados, aes(x = factor(voluntario), y = diferenca)) +
  geom_bar(stat = "identity", fill = "darkgreen", alpha = 0.8) +
  labs(title = "Diferença (Antes - Depois) por Voluntário", 
       x = "Voluntário", y = "Diferença de pH") +
  tema_padrao +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

# 4.4 Gráfico de Dispersão com Linhas de Média e pH Crítico
linha_critica <- 5.5

g_disp_antes <- ggplot(dados, aes(x = factor(voluntario), y = antes)) +
  geom_point(color = "skyblue", size = 3) +
  geom_hline(yintercept = mean(dados$antes), color = "red", linetype = "dashed", linewidth = 1) +
  geom_hline(yintercept = linha_critica, color = "black", linewidth = 1) +
  annotate("text", x = 15, y = mean(dados$antes) + 1, 
           label = paste("Média =", round(mean(dados$antes), 2)), color = "red") +
  labs(title = "Dispersão 'Antes'", x = "Voluntário", y = "pH") +
  ylim(0, max(dados_long$pH) + 1) +
  tema_padrao +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

g_disp_depois <- ggplot(dados, aes(x = factor(voluntario), y = depois)) +
  geom_point(color = "orange", size = 3) +
  geom_hline(yintercept = mean(dados$depois), color = "red", linetype = "dashed", linewidth = 1) +
  geom_hline(yintercept = linha_critica, color = "black", linewidth = 1) +
  annotate("text", x = 10, y = mean(dados$depois) + 1, 
           label = paste("Média =", round(mean(dados$depois), 2)), color = "red") +
  labs(title = "Dispersão 'Depois'", x = "Voluntário", y = "pH") +
  ylim(0, max(dados_long$pH) + 1) +
  tema_padrao +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

# Organizando os gráficos lado a lado e exibindo
grid.arrange(g_disp_antes, g_disp_depois, ncol = 2)

# 5. Teste de Hipótese ---------------------------------------------------------
cat("\n--- Teste t Pareado ---\n")
teste_hipotese <- t.test(dados$antes, dados$depois, paired = TRUE)
print(teste_hipotese)
