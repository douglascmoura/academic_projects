# ==============================================================================
# Análise Longitudinal: Estudo Pré e Pós-Teste (Pressão Arterial Média - PAM)
# Autor: Douglas Chaves Moura
# ==============================================================================

# 1. Pacotes e Configurações Iniciais ------------------------------------------
library(readxl)
library(psych)
library(dplyr)
library(tidyr)
library(ggplot2)
library(GGally)
library(gridExtra)
library(lmerTest) # Carrega lme4 com p-values
library(car)
library(qqplotr)
library(emmeans)

# Tema customizado para os gráficos
tema.custom <- theme_minimal() + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 13, face = "bold"),
    axis.text = element_text(size = 14),
    strip.text = element_text(size = 13, face = "bold", color = "black")
  )

# 2. Importação e Preparação dos Dados -----------------------------------------
data <- read_excel("dados/Singer&Nobre&Rocha2017exemp531.xls")

data.indometacina <- data %>% filter(Grupo == "indometacina") %>% select(Cão, Antes, Depois)
data.nifedipina <- data %>% filter(Grupo == "nifedipina") %>% select(Cão, Antes, Depois)

data.long <- data %>%
  pivot_longer(cols = c("Antes", "Depois"), names_to = "Tempo", values_to = "Valor") %>%
  mutate(Tempo = factor(Tempo, levels = c("Antes", "Depois")))

# 3. Análise Descritiva --------------------------------------------------------
cat("\n--- Estatísticas Descritivas por Grupo ---\n")
describeBy(data[,c(3,4)], group = data$Grupo)

# Matrizes de Dispersão
disp_indo <- ggpairs(
  data.indometacina[,-1],
  upper = list(continuous = wrap("cor", size = 5.5, color = "black")), 
  lower = list(continuous = wrap("points", alpha = 0.8, color = "black")),
  diag = list(continuous = wrap("densityDiag", fill = "black", alpha = 0.5))
) + tema.custom

disp_nife <- ggpairs(
  data.nifedipina[,-1],
  upper = list(continuous = wrap("cor", size = 5.5, color = "darkred")), 
  lower = list(continuous = wrap("points", alpha = 0.8, color = "darkred")), 
  diag = list(continuous = wrap("densityDiag", fill = "darkred", alpha = 0.5))
) + tema.custom

# 4. Análise Gráfica Exploratória ----------------------------------------------
# 4.1. Perfis individuais
g_perfis <- ggplot(data.long, aes(x = Tempo, y = Valor, group = Cão, color = Grupo, shape = Grupo, linetype = Grupo)) +
  geom_line(linewidth = 1.3) +
  geom_point(size = 3) +
  scale_color_manual(values = c("indometacina" = "black", "nifedipina" = "darkred")) +
  scale_shape_manual(values = c("indometacina" = 16, "nifedipina" = 1)) +  
  scale_linetype_manual(values = c("indometacina" = "solid", "nifedipina" = "dashed")) +
  labs(x = "", y = "PAM em mmHg", title = "Perfis Individuais") +
  theme_minimal()

# 4.2. Média e IC de 95%
calc.ic <- function(x) {
  n <- length(x)
  media <- mean(x, na.rm = TRUE)
  ep <- sd(x, na.rm = TRUE) / sqrt(n) 
  ic_inf <- media - qt(0.975, df = n - 1) * ep
  ic_sup <- media + qt(0.975, df = n - 1) * ep
  return(c(media, ic_inf, ic_sup))
}

medias.ic <- data.frame(
  Grupo = rep(c("indometacina", "nifedipina"), each = 2),
  Tempo = rep(c("Antes", "Depois"), 2),
  Valor_Medio = c(calc.ic(data.indometacina$Antes)[1], calc.ic(data.indometacina$Depois)[1], 
                  calc.ic(data.nifedipina$Antes)[1], calc.ic(data.nifedipina$Depois)[1]),
  ic_inf = c(calc.ic(data.indometacina$Antes)[2], calc.ic(data.indometacina$Depois)[2], 
             calc.ic(data.nifedipina$Antes)[2], calc.ic(data.nifedipina$Depois)[2]),
  ic_sup = c(calc.ic(data.indometacina$Antes)[3], calc.ic(data.indometacina$Depois)[3], 
             calc.ic(data.nifedipina$Antes)[3], calc.ic(data.nifedipina$Depois)[3])
) %>% mutate(Tempo = factor(Tempo, levels = c("Antes", "Depois")))

g_perfil_medio <- ggplot(medias.ic, aes(x = Tempo, y = Valor_Medio, group = Grupo, color = Grupo, shape = Grupo)) +
  geom_line(data = data.long, aes(x = Tempo, y = Valor, group = Cão, color = Grupo, linetype = Grupo), 
            linewidth = 1.3, alpha = 0.2) +
  geom_line(aes(linetype = Grupo), linewidth = 1.3) +
  geom_point(size = 3) +
  geom_ribbon(aes(ymin = ic_inf, ymax = ic_sup, fill = Grupo), alpha = 0.5, color = NA) +
  scale_color_manual(values = c("indometacina" = "black", "nifedipina" = "darkred")) +
  scale_fill_manual(values = c("indometacina" = "black", "nifedipina" = "darkred")) +
  scale_shape_manual(values = c("indometacina" = 16, "nifedipina" = 1)) +
  scale_linetype_manual(values = c("indometacina" = "solid", "nifedipina" = "dashed")) +
  labs(x = "", y = "PAM em mmHg", title = "Perfil Médio (IC 95%)") +
  theme_minimal()

# 5. Modelagem Linear Mista (LMM) ----------------------------------------------
# Renomeando colunas para o modelo
dados_long <- data %>%
  pivot_longer(cols = c("Antes", "Depois"), names_to = "Tempo", values_to = "PAM") %>%
  mutate(Tempo = factor(Tempo, levels = c("Antes", "Depois")))

modelo_mlm <- lmer(PAM ~ Grupo * Tempo + (1 | Cão), data = dados_long)

cat("\n--- Resumo do Modelo Linear Misto ---\n")
summary(modelo_mlm)
anova(modelo_mlm)

# Testes Post-Hoc (Comparações Múltiplas)
cat("\n--- Comparações Múltiplas (emmeans) ---\n")
emmeans(modelo_mlm, pairwise ~ Tempo)
emmeans(modelo_mlm, pairwise ~ Grupo)
emmeans(modelo_mlm, pairwise ~ Tempo | Grupo)

# 6. Diagnóstico do Modelo -----------------------------------------------------
# QQ-Plot com qqplotr
residuos <- resid(modelo_mlm, type = "working")

g_qqplot <- ggplot(data.frame(residuos), aes(sample = residuos)) +
  stat_qq_band(alpha = 0.2, fill = "blue") +  
  stat_qq_line(color = "purple") +            
  stat_qq_point(color = "#031025") +          
  labs(title = "QQ-Plot (Resíduos de Trabalho)", x = "Quantis Teóricos", y = "Quantis Amostrais") +
  theme_minimal()

print(g_qqplot)

# Teste de Shapiro-Wilk
shapiro.test(resid(modelo_mlm))

# Gráfico de Homocedasticidade
plot(modelo_mlm, which = 1,
     xlab = "Valores Ajustados",
     ylab = "Resíduos", col = "purple",
     main = "Resíduos vs Ajustados")