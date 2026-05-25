# ==============================================================================
# Análise Longitudinal: Crescimento e Ganho de Peso em Suínos
# Autor: Douglas Chaves Moura
# ==============================================================================

# 1. Pacotes e Configurações Iniciais ------------------------------------------
library(SemiPar)
library(dplyr)
library(psych)
library(GGally)
library(ggplot2)
library(joineR)
library(nlme)
library(lme4)
library(lmtest)
library(car)

tema.custom <- theme_minimal() + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 11, face = "bold"),
    strip.text = element_text(size = 10, face = "bold", color = "#031025")
  )

# 2. Base de Dados -------------------------------------------------------------
data(pig.weights)
data <- pig.weights
colnames(data) <- c("id.num", "num.semanas", "peso")

# 3. Análise Descritiva e Visualização -----------------------------------------
cat("\n--- Estatísticas Descritivas por Semana ---\n")
describeBy(data$peso, group = data$num.semanas)

# Perfis Individuais
ggplot(data, aes(x = num.semanas, y = peso, group = id.num)) +
  geom_line(alpha = 0.8, color = "#0f52ba", linewidth = 0.8) +
  labs(x = "Semana", y = "Peso (em libras)", title = "Perfis Individuais de Crescimento") +
  scale_x_continuous(breaks = 1:9) +
  theme_minimal()

# Variograma (Verificando dependência temporal)
variograma.2 <- variogram(indv = data$id.num, time = data$num.semanas, Y = data$peso)
plot(variograma.2, main = "Variograma Empírico")

# 4. Modelagem Longitudinal ----------------------------------------------------
cat("\n--- Ajuste dos Modelos ---\n")

# Modelo 1: Linear Simples (MLS)
modelo_linear <- lm(peso ~ num.semanas, data = data)

# Modelo 2: Heterocedástico sem correlação (MLMH)
modelo_heterocedastico <- lme(peso ~ num.semanas, random = ~ 1 | id.num, 
                              weights = varIdent(form = ~ 1 | num.semanas), data = data)

# Modelo 3: Efeito Aleatório de Tempo (lme4)
modelo_efeito_tempo <- lmer(peso ~ num.semanas + (num.semanas | id.num), data = data)

# Modelo 4: ARH(1) - Autoregressivo Heteroscedástico (varIdent)
modelo_arh1 <- lme(peso ~ num.semanas, random = ~ 1 | as.factor(id.num), 
                   correlation = corAR1(form = ~ num.semanas | as.factor(id.num)),
                   weights = varIdent(form = ~ 1 | num.semanas), 
                   data = data, control = lmeControl(opt = "optim", maxIter = 200))

# Modelo 5: ARp(1) - Autoregressivo com Heterocedasticidade Potência (varPower)
modelo_arp1 <- lme(peso ~ num.semanas, random = ~ 1 | id.num,
                   correlation = corAR1(form = ~ num.semanas | id.num),
                   weights = varPower(form = ~ num.semanas), data = data)

# Modelo 6: ARMAH(1,1) - Estrutura ARMA com varIdent
modelo_armah11 <- lme(peso ~ num.semanas, random = ~ 1 | id.num, 
                      correlation = corARMA(form = ~ num.semanas | id.num, p = 1, q = 1), 
                      weights = varIdent(form = ~ 1 | num.semanas), 
                      data = data, control = lmeControl(maxIter = 100, msMaxIter = 100, tolerance = 1e-6))

# Seleção de Modelos (AIC/BIC)
cat("\nCritérios de Informação (AIC / BIC):\n")
AIC(modelo_linear, modelo_heterocedastico, modelo_efeito_tempo, modelo_arh1, modelo_arp1, modelo_armah11)
BIC(modelo_linear, modelo_heterocedastico, modelo_efeito_tempo, modelo_arh1, modelo_arp1, modelo_armah11)

# 5. Predições e Visualização dos Ajustes --------------------------------------
data$pred_linear <- predict(modelo_linear, newdata = data)
data$pred_arh1 <- predict(modelo_arh1, newdata = data)
data$pred_arp1 <- predict(modelo_arp1, newdata = data)

# Visualizando o ajuste do ARH(1) comparado ao Perfil Médio e Linear
ggplot(data, aes(x = num.semanas, y = peso)) +
  geom_point(color = "gray50", alpha = 0.5) +
  geom_line(aes(group = id.num), color = "gray70", alpha = 0.5) +
  geom_line(aes(y = pred_linear, color = "Linear"), linewidth = 1.5, linetype = 2) +
  geom_line(aes(y = pred_arh1, color = "ARH(1)"), linewidth = 1.7) +
  labs(x = "Semana", y = "Peso (em libras)", title = "Ajuste do Modelo ARH(1)") +
  scale_color_manual(name = "Modelos:", values = c("ARH(1)" = "#0f52ba", "Linear" = "orange")) +
  scale_x_continuous(breaks = 1:9) +
  theme_bw()

# 6. Diagnóstico do Modelo Escolhido (ARH1) ------------------------------------
par(mfrow = c(2,2))

# 6.1 Resíduos vs Ajustados
plot(fitted(modelo_arh1), residuals(modelo_arh1, type = "normalized"),
     xlab = "Valores preditos", ylab = "Resíduos padronizados", main = "Resíduos vs Ajustados")
abline(h = c(-3, 0, 3), col = c("#FF4500", "#0f52ba", "#FF4500"), lty = c(2, 1, 2), lwd = 2)

# 6.2 QQ-Plot dos resíduos
qqPlot(residuals(modelo_arh1, type = "normalized"), col = "#031025", col.lines = "#0f52ba",
       id = F, main = "QQ-Plot com envelope (ARH1)", xlab = "Quantis Teóricos", ylab = "Quantis Amostrais")

# 6.3 Resíduos marginais ao longo do tempo
plot(data$num.semanas, residuals(modelo_arh1, type = "response"),
     pch = 19, xlab = "Semana", ylab = "Resíduos Marginais", main = "Resíduos ao longo do tempo")
abline(h = 0, col = "#0f52ba", lwd = 2)

# 6.4 Distância de Cook
cooksd_lme <- function(model) {
  X <- model.matrix(formula(model), data = model$data) 
  beta <- fixef(model) 
  vcov_beta <- vcov(model)
  res <- residuals(model, type = "normalized")
  H <- X %*% solve(t(X) %*% X) %*% t(X)
  cooksd <- (res^2) * diag(H) / (nrow(vcov_beta) * (1 - diag(H))^2)
  return(cooksd)
}
data$cooksd_arh1 <- cooksd_lme(modelo_arh1)

plot(data$cooksd_arh1, pch = 19, ylab = "Distância de Cook", xlab = "Índice", main = "Distância de Cook")
abline(h = 4/nrow(data), col = "#0f52ba", lwd = 2)

par(mfrow = c(1,1))

# Função de Autocorrelação (ACF) dos resíduos
ACF_res.arh1 <- ACF(modelo_arh1, maxLag = 5, resType = "normalized")
plot(ACF_res.arh1, alpha = 0.05, main = "ACF dos Resíduos: ARH(1)", col = "#0f52ba")
