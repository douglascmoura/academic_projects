# ==============================================================================
# ANÁLISE DE SÉRIES TEMPORAIS: Variação dos Gastos de Consumo Pessoal
# Autor: Douglas Chaves Moura
# Descrição: Roteiro passo a passo para análise e modelagem de séries temporais 
# usando a metodologia Box-Jenkins.
# ==============================================================================

# 0. CONFIGURAÇÃO INICIAL ------------------------------------------------------

# Carregamento de bibliotecas
suppressPackageStartupMessages({
  library(fpp2)          # Dados e funções de forecast
  library(forecast)      # Funções principais para modelagem
  library(tseries)       # Testes estatísticos para séries temporais
  library(readxl)        # Leitura de arquivos Excel
  library(Kendall)       # Teste de Mann-Kendall
  library(randtests)     # Teste de Cox-Stuart
  library(seastests)     # Testes de sazonalidade
  library(dplyr)         # Manipulação de dados
  library(ggplot2)       # Gráficos
  library(psych)         # Estatísticas descritivas
})

# Configuração global de gráficos
configurar_graficos <- function() {
  par(mfrow = c(1, 1),     # Define a dimensão da janela gráfica
      cex.axis = 2,        # Aumenta os números dos eixos
      cex.lab = 2.2,       # Aumenta os rótulos dos eixos (xlab, ylab)
      cex.main = 2.7,      # Aumenta o título do gráfico
      lwd = 2.7,           # Aumenta a espessura das linhas
      mar = c(5, 5, 2, 2)) # Aumenta as margens (baixo, esquerda, cima, direita)
}
configurar_graficos()

# 1. CARREGAMENTO E PREPARAÇÃO DOS DADOS ---------------------------------------

# Leitura dos dados (Caminho relativo para o repositório)
dados_consumo <- read_excel("dados/consumo.xlsx", col_types = c("numeric"))

# Criação da série temporal (Trimestral, 1970 a 2016)
serie_consumo <- ts(dados_consumo$x, start = c(1970, 1), end = c(2016, 3), frequency = 4)

# Informações básicas da série
cat("=== INFORMAÇÕES BÁSICAS DA SÉRIE ===\n")
cat("Classe:", class(serie_consumo), "\n")
cat("Início:", start(serie_consumo), "\n")
cat("Fim:", end(serie_consumo), "\n")
cat("Frequência:", frequency(serie_consumo), "\n")
cat("Resumo estatístico:\n")
print(summary(serie_consumo))

# Estatísticas descritivas detalhadas
describe(serie_consumo)
describeBy(serie_consumo, cycle(serie_consumo))

# 2. ANÁLISE EXPLORATÓRIA ------------------------------------------------------

# Gráfico principal da série
autoplot(serie_consumo, lwd = 2, color = "black") +
  labs(y = "Variação dos gastos de consumo pessoal (por Trimestre)", x = "Tempo") +
  theme_bw(base_size = 18) +
  theme(
    panel.grid.minor = element_blank(),
    axis.title = element_text(face = "bold", size = 22),
    axis.text = element_text(size = 22),
    plot.title = element_text(face = "bold", size = 20, hjust = 0.5)
  )

# Decomposição da série
decomposicao_serie <- decompose(serie_consumo, type = "additive")
plot(decomposicao_serie)

# Análise de sazonalidade
ggseasonplot(serie_consumo, xlab = "Trimestre", ylab = "Variação percentual") +
  labs(title = "") +
  theme_bw(base_size = 18) +
  theme(
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(size = 20),
    legend.position = "bottom",
    legend.direction = "horizontal", 
    legend.key.width = unit(1.5, "cm"),
    panel.grid.minor = element_blank(),
    axis.title = element_text(face = "bold", size = 22),
    axis.text = element_text(size = 22),
    plot.title = element_text(face = "bold", size = 20, hjust = 0.5)
  ) +
  guides(colour = guide_legend(ncol = 7))

# Histograma e densidade
hist(serie_consumo, freq = FALSE, main = "", xlab = "Valores da série", 
     ylab = "Densidade", col = "seagreen", lwd = 1.5)
lines(seq(min(serie_consumo), max(serie_consumo), length = 100),
      dnorm(seq(min(serie_consumo), max(serie_consumo), length = 100),
            mean = mean(serie_consumo), sd = sd(serie_consumo)), 
      col = "black", lwd = 4)

# Boxplot por trimestre
boxplot(serie_consumo ~ cycle(serie_consumo), main = "",
        xlab = "Trimestre", ylab = "Valores", col = "seagreen")

# 3. TESTES ESTATÍSTICOS -------------------------------------------------------

cat("\n=== TESTES DE ESTACIONARIEDADE ===\n")
# Teste de Dickey-Fuller Aumentado (ADF)
adf.test(serie_consumo)

# Teste de Kwiatkowski-Phillips-Schmidt-Shin (KPSS)
kpss.test(serie_consumo)

cat("\n=== TESTES DE TENDÊNCIA ===\n")
# Teste de Mann-Kendall
MannKendall(serie_consumo)

# Teste de Regressão Linear para Tendência
tempo <- 1:length(serie_consumo)
modelo_tendencia <- lm(serie_consumo ~ tempo)
summary(modelo_tendencia)

cat("\n=== TESTES DE SAZONALIDADE ===\n")
# Teste QS (Quadratic Spectral) para Sazonalidade
qs(serie_consumo, freq = frequency(serie_consumo))

# 4. ANÁLISE DE VARIABILIDADE --------------------------------------------------

cat("\n=== ANÁLISE DE VARIABILIDADE ===\n")
cat("Variância da série original:", var(serie_consumo), "\n")
cat("Variância da série diferenciada:", var(diff(serie_consumo)), "\n")
# Nota: Transformação logarítmica não é possível devido a valores próximos de zero

# 5. ANÁLISE DE AUTOCORRELAÇÃO -------------------------------------------------

# Gráficos ACF e PACF
ggAcf(serie_consumo) + labs(title = "") +
  theme_bw(base_size = 18) +
  theme(panel.grid.minor = element_blank(),
        axis.title = element_text(face = "bold", size = 22),
        axis.text = element_text(size = 22))

ggPacf(serie_consumo) + labs(title = "") +
  theme_bw(base_size = 18) +
  theme(panel.grid.minor = element_blank(),
        axis.title = element_text(face = "bold", size = 22),
        axis.text = element_text(size = 22))

# 6. MODELAGEM ARIMA (Metodologia Box-Jenkins) ---------------------------------

# Função para avaliação de modelos
avaliar_modelo <- function(modelo, nome_modelo) {
  cat("\n=== AVALIAÇÃO DO MODELO", nome_modelo, "===\n")
  print(summary(modelo))
  
  cat("\n--- Teste de Ljung-Box ---\n")
  print(Box.test(modelo$residuals, lag = 10, type = "Ljung-Box"))
  
  cat("\n--- Teste de Jarque-Bera ---\n")
  print(jarque.bera.test(modelo$residuals))
  
  cat("\n--- Teste de Shapiro-Wilk ---\n")
  if(length(modelo$residuals) <= 5000) {
    print(shapiro.test(modelo$residuals))
  } else {
    cat("Amostra muito grande para o teste de Shapiro-Wilk\n")
  }
  return(modelo)
}

# Função para diagnóstico gráfico dos resíduos
diagnosticar_residuos <- function(modelo, nome_modelo) {
  # ACF dos resíduos
  print(ggAcf(modelo$residuals) + 
          labs(title = paste("ACF dos Resíduos -", nome_modelo)) + theme_bw(base_size = 18))
  
  # PACF dos resíduos
  print(ggPacf(modelo$residuals) + 
          labs(title = paste("PACF dos Resíduos -", nome_modelo)) + theme_bw(base_size = 18))
  
  # Histograma dos resíduos
  hist(modelo$residuals, freq = FALSE,
       main = paste("Distribuição dos Resíduos -", nome_modelo),
       xlab = "Resíduos", ylab = "Densidade", col = "seagreen", lwd = 1.5, breaks = 30)
  lines(seq(min(modelo$residuals), max(modelo$residuals), length = 100),
        dnorm(seq(min(modelo$residuals), max(modelo$residuals), length = 100),
              mean = mean(modelo$residuals), sd = sd(modelo$residuals)), 
        col = "black", lwd = 4)
  
  # Q-Q plot
  qqnorm(modelo$residuals, main = paste("Q-Q Plot -", nome_modelo),
         xlab = "Quantis Teóricos", ylab = "Quantis Amostrais", lwd = 3)
  qqline(modelo$residuals, col = "seagreen", lwd = 4)
  
  # Teste de Ljung-Box para diferentes lags
  ljung_box_plot <- function(residuos, max_lag = 25) {
    ljung_p <- numeric(max_lag)
    for (i in 1:max_lag) {
      ljung_p[i] <- Box.test(residuos, lag = i, type = "Ljung-Box")$p.value
    }
    plot(1:max_lag, ljung_p, type = "b", lwd = 3, ylim = c(0, 1), 
         main = paste("Teste de Ljung-Box -", nome_modelo),
         xlab = "Lag", ylab = "Valor-p")
    abline(h = 0.05, col = "blue", lty = 2)
  }
  ljung_box_plot(modelo$residuals)
}

cat("\n=== AJUSTE DE MODELOS ===\n")

# Modelo AR(3)
modelo_ar3 <- arima(serie_consumo, order = c(3, 0, 0))
modelo_ar3 <- avaliar_modelo(modelo_ar3, "AR(3)")
diagnosticar_residuos(modelo_ar3, "AR(3)")

# Modelo MA(3)
modelo_ma3 <- arima(serie_consumo, order = c(0, 0, 3), include.mean = TRUE)
modelo_ma3 <- avaliar_modelo(modelo_ma3, "MA(3)")
diagnosticar_residuos(modelo_ma3, "MA(3)")

# Modelo ARMA(3,3)
modelo_arma33 <- arima(serie_consumo, order = c(3, 0, 3))
modelo_arma33 <- avaliar_modelo(modelo_arma33, "ARMA(3,3)")
diagnosticar_residuos(modelo_arma33, "ARMA(3,3)")

# Modelo Automático (Auto.Arima)
modelo_auto <- auto.arima(serie_consumo, seasonal = FALSE, stepwise = FALSE, approximation = FALSE, d = 0)
modelo_auto <- avaliar_modelo(modelo_auto, "AUTO")

# 7. COMPARAÇÃO DE MODELOS E ESCOLHA -------------------------------------------

modelos <- list(
  "AR(3)" = modelo_ar3,
  "MA(3)" = modelo_ma3,
  "ARMA(3,3)" = modelo_arma33,
  "AUTO" = modelo_auto
)

criterios <- data.frame(
  Modelo = names(modelos),
  AIC = sapply(modelos, AIC),
  BIC = sapply(modelos, BIC),
  stringsAsFactors = FALSE
)

cat("\n=== COMPARAÇÃO DE MODELOS ===\n")
print(criterios)

# Melhor modelo por AIC
melhor_modelo <- modelos[[which.min(criterios$AIC)]]
cat("\nMelhor modelo por AIC:", criterios$Modelo[which.min(criterios$AIC)], "\n")

# 8. DIAGNÓSTICO FINAL ---------------------------------------------------------
cat("\n=== DIAGNÓSTICO FINAL DO MELHOR MODELO ===\n")
checkresiduals(melhor_modelo)
tsdiag(melhor_modelo)
autoplot(melhor_modelo)

cat("\n=== ANÁLISE CONCLUÍDA ===\n")