# ==============================================================================
# ANÁLISE DE SÉRIES TEMPORAIS: Níveis de Ozônio (1956-1970)
# Autor: Douglas Chaves Moura
# Descrição: Modelagem SARIMA e Previsão (Metodologia Box-Jenkins)
# ==============================================================================

# --------------------------------------------------
# 1. CONFIGURAÇÃO INICIAL E CARREGAMENTO DOS DADOS
# --------------------------------------------------

library(fpp2)
library(tseries)
library(readxl)
library(Kendall)
library(scales)
library(ggplot2)

# Carregando os dados (assumindo que o arquivo "A4-OZONIO.XLS" está na pasta dataset)
dados <- read_excel("dataset/A4-OZONIO.XLS", col_types = c("text", "numeric", "numeric"))

# Criando o objeto de série temporal (ts)
serie_ozonio <- ts(dados$Ozonio, start = c(1956, 1), frequency = 12)

# -----------------------------------------------
# 2. ANÁLISE EXPLORATÓRIA E TESTES DE HIPÓTESES
# -----------------------------------------------

# Visualização inicial da série
autoplot(serie_ozonio, lwd = 2) +
  xlab("Ano") +
  ylab("Nível de Ozônio") +
  theme_bw()

# Decomposição (para análise visual)
decomposicao <- decompose(serie_ozonio, type = "multiplicative")
plot(decomposicao)

# Boxplot sazonal
boxplot(serie_ozonio ~ cycle(serie_ozonio),
        xlab = "Mês", ylab = "Nível de Ozônio")

# -- Testes de Estacionariedade (série original) --
cat("\n=== TESTE DE ESTACIONARIEDADE (SÉRIE ORIGINAL) ===\n")
# H0: série não é estacionária
adf.test(serie_ozonio)
# H0: série é estacionária
kpss.test(serie_ozonio)
# Conclusão: A combinação dos testes sugere estacionariedade.

# -- Testes de Tendência --
cat("\n=== TESTES DE TENDÊNCIA ===\n")
# H0: não há tendência
MannKendall(serie_ozonio)
tempo <- 1:length(serie_ozonio)
summary(lm(serie_ozonio ~ tempo))
# Conclusão: Não há evidência de tendência monotônica.

# -- Teste de Sazonalidade --
cat("\n=== TESTE DE SAZONALIDADE ===\n")
# H0: não há sazonalidade
qs(serie_ozonio, freq = frequency(serie_ozonio))
# Conclusão: Existe sazonalidade significativa.

# -- Análise de Variabilidade (Transformação Log) --
cat("\n=== ANÁLISE DE VARIABILIDADE ===\n")
cat("Variância da série original:", var(serie_ozonio), "\n")
cat("Variância do log da série:", var(log(serie_ozonio)), "\n")
# Conclusão: Ganho não é relevante. Manter série original pela interpretabilidade.

# -- Análise das Diferenças para tornar estacionária --
# Primeira diferença não sazonal (d=1)
adf.test(diff(serie_ozonio))
kpss.test(diff(serie_ozonio))
# Primeira diferença sazonal (D=1)
adf.test(diff(serie_ozonio, lag = 12))
kpss.test(diff(serie_ozonio, lag = 12))
# Conclusão: Ambas as diferenciações são eficazes.

# -----------------------------------------------
# 3. IDENTIFICAÇÃO E ESTIMAÇÃO DO MODELO SARIMA
# -----------------------------------------------

# Análise ACF/PACF da série original para guiar a modelagem
ggtsdisplay(serie_ozonio)
# Observações: Forte padrão sazonal. Decaimento lento no ACF. PACF com pico no lag 1.
# Sugere SARIMA(1,d,q)(P,D,Q)[12] com D=1.

# -- Modelo 1: Primeira tentativa --
modelo.1 <- Arima(serie_ozonio,
                  order = c(1,0,0),
                  seasonal = c(0,1,1),
                  include.drift = FALSE)
summary(modelo.1)
ggtsdisplay(modelo.1$residuals)
# Diagnóstico: Resíduos mostram autocorrelação significativa no lag 9.

# -- Modelo 2: Modelo final com ajuste fino --
# Para corrigir o lag 9, adicionamos um MA(9) mas fixando os termos
# intermediários (ma2 a ma8) em zero para um modelo mais parcimonioso.
modelo.2 <- Arima(serie_ozonio,
                  order = c(1,0,9),
                  seasonal = c(0,1,1),
                  fixed = c(NA, 0,0,0,0,0,0,0,0, NA, NA))
# fixed = c(ar1, ma1, ma2, ma3, ma4, ma5, ma6, ma7, ma8, ma9, sma1)
# NA = estimar; 0 = fixar em zero.

summary(modelo.2)
ggtsdisplay(modelo.2$residuals)
# Diagnóstico: ACF/PACF dos resíduos agora parecem ruído branco.

# -------------------------------------------
# 4. DIAGNÓSTICO DO MODELO FINAL (MODELO 2)
# -------------------------------------------

# Teste de Ljung-Box para diferentes lags
ljung_box_plot <- function(residuos, max_lag = 50) {
  ljung_p <- numeric(max_lag)
  for (i in 1:max_lag) {
    ljung_p[i] <- Box.test(residuos, lag = i, type = "Ljung-Box")$p.value
  }
  
  # Criando o dataframe para o ggplot
  df_ljung <- data.frame(
    Lag = 1:max_lag,
    P_Value = ljung_p
  )
  
  # Usando ggplot para criar o gráfico
  ggplot(df_ljung, aes(x = Lag, y = P_Value)) +
    geom_point(size = 3, color = "black") +  
    geom_hline(yintercept = 0.05, color = "blue", linetype = "dashed", linewidth = 1.5) +  
    scale_x_continuous(breaks = seq(6, max_lag, by = 6)) +  
    scale_y_continuous(labels = label_comma(big.mark = ".", decimal.mark = ",")) +
    labs(title = "", x = "Lag", y = "Valor-p") +
    theme_bw(base_size = 18) +  
    theme(
      panel.grid.minor = element_blank(),
      axis.title = element_text(face = "bold", size = 22),
      axis.text = element_text(size = 22),
      plot.title = element_text(face = "bold", size = 20, hjust = 0.5)
    )
}
# A hipótese nula (H0) é que os resíduos são independentes. 
ljung_box_plot(modelo.2$residuals)
# Conclusão: Todos os p-valores estão acima de 0.05. Os resíduos são independentes.

# -- Diagnóstico completo com checkresiduals --
checkresiduals(modelo.2)

# -- Teste de Normalidade dos Resíduos --
# H0: Resíduos são normalmente distribuídos.
shapiro.test(modelo.2$residuals)
# Conclusão: p-valor (0.4574) > 0.05. Não se rejeita H0. Resíduos são normais.

# Verificação visual da normalidade com Gráfico Q-Q
qqnorm(modelo.2$residuals, main="", lwd = 3)
qqline(modelo.2$residuals, col = "blue", lwd = 4)

# -------------
# 5. PREVISÃO
# -------------

# Gerar previsões para os próximos 12 meses
previsao_modelo.2 <- forecast(modelo.2, h = 12)

# Visualizar as previsões com a série original
autoplot(serie_ozonio, linewidth = 2) +
  autolayer(previsao_modelo.2, series = "Previsão", PI = TRUE, linewidth = 2) +
  xlab("Ano") +
  ylab("Nível de Ozônio") +
  guides(colour=guide_legend(title="Séries")) +
  theme_bw()