#-----------------------------------------------------------------------
#            ANÁLISE ESPACIAL DO ÍNDICE DE PROGRESSO SOCIAL (IPS)
#                       BRASIL - 2024 vs. 2025
# Autor: Douglas Chaves Moura
#-----------------------------------------------------------------------

# --- 1. CONFIGURAÇÃO INICIAL E PACOTES ---
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(psych)
library(sf)
library(geobr)
library(RColorBrewer)
library(scales)

# --- 2. CARGA E PREPARAÇÃO DOS DADOS ---
# Utilizando caminhos relativos (assumindo que o working directory é a raiz do projeto)
ips_2024 <- read_excel("datasets/IPSBrasil2024.xlsx", sheet = 1,
                       col_types = c("numeric", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric"))

ips_2025 <- read_excel("datasets/IPSBrasil2025.xlsx", sheet = 1, 
                       col_types = c("numeric", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Renomeando as colunas para padronização
colunas_nomes <- c("codigo_ibge", "municipio", "uf", "ips", "moradia", "seguranca_pessoal", "saude_bem_estar", "subnutricao")
names(ips_2024) <- colunas_nomes
names(ips_2025) <- colunas_nomes

# --- 3. ANÁLISE DESCRITIVA (2024) ---
cat("\n--- Estatísticas Descritivas: IPS 2024 ---\n")
describe(ips_2024$ips)
describeBy(ips_2024$ips, group = ips_2024$uf)

# Gráfico: Média do IPS por Estado (2024)
ggplot(ips_2024 %>% group_by(uf) %>% summarise(media_ips = mean(ips)), 
       aes(x = reorder(uf, media_ips), y = media_ips, fill = media_ips)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = format(round(media_ips, 1), decimal.mark = ",")), hjust = -0.1, size = 5) +
  coord_flip() +
  labs(x = "Estado (UF)", y = "Média do IPS") +
  scale_fill_gradient(low = "lightcoral", high = "darkred") +
  theme_bw(base_size = 18) +
  theme(legend.position = "none", panel.grid.minor = element_blank())

# --- 4. ANÁLISE ESPACIAL: BOXMAP (2024) ---
# Download das malhas espaciais do IBGE via geobr
municipios_brasil <- read_municipality(year = 2020, showProgress = FALSE)
estados_brasil <- read_state(year = 2020, showProgress = FALSE)

dados_mapa_2024 <- left_join(municipios_brasil, ips_2024, by = c("code_muni" = "codigo_ibge"))

# Função para classificar os dados no padrão Boxmap
classify_boxplot <- function(valor, stats_calculadas) {
  case_when(
    is.na(valor)                  ~ "Sem Dados",
    valor > stats_calculadas[5]   ~ "Outlier Superior",
    valor >= stats_calculadas[4]  ~ "> 75%",
    valor >= stats_calculadas[3]  ~ "50% - 75%",
    valor >= stats_calculadas[2]  ~ "25% - 50%",
    valor >= stats_calculadas[1]  ~ "< 25%",
    valor < stats_calculadas[1]   ~ "Outlier Inferior",
    TRUE                          ~ "Sem Dados"
  )
}

ordem_categorias <- c("Outlier Superior", "> 75%", "50% - 75%", "25% - 50%", "< 25%", "Outlier Inferior", "Sem Dados")
stats_2024 <- boxplot.stats(na.omit(dados_mapa_2024$ips))$stats
names(stats_2024) <- c("min", "Q1", "mediana", "Q3", "max")

dados_mapa_2024 <- dados_mapa_2024 %>%
  mutate(Categoria = factor(classify_boxplot(ips, stats_2024), levels = ordem_categorias))

# Preparação de legendas e contagens para o mapa
contagem_cat_2024 <- dados_mapa_2024 %>% st_drop_geometry() %>% count(Categoria) %>% complete(Categoria, fill = list(n = 0))

faixas_valores_24 <- tibble(
  Categoria = ordem_categorias,
  Intervalo = c(
    paste0("[", format(stats_2024["max"], decimal.mark = ",", digits = 2), "+]"),
    paste0("[", format(stats_2024["Q3"], decimal.mark = ",", digits = 2), " – ", format(stats_2024["max"], decimal.mark = ",", digits = 2), "]"),
    paste0("[", format(stats_2024["mediana"], decimal.mark = ",", digits = 2), " – ", format(stats_2024["Q3"], decimal.mark = ",", digits = 2), ")"),
    paste0("[", format(stats_2024["Q1"], decimal.mark = ",", digits = 2), " – ", format(stats_2024["mediana"], decimal.mark = ",", digits = 2), ")"),
    paste0("[", format(stats_2024["min"], decimal.mark = ",", digits = 2), " – ", format(stats_2024["Q1"], decimal.mark = ",", digits = 2), ")"),
    paste0("[<", format(stats_2024["min"], decimal.mark = ",", digits = 2), "]"), ""
  )
)

legenda_24 <- contagem_cat_2024 %>% left_join(faixas_valores_24, by = "Categoria") %>%
  mutate(Cat_Legenda = ifelse(Categoria == "Sem Dados", "Sem Dados (0)", paste0(Categoria, " ", Intervalo, " (", n, ")")))

dados_mapa_2024 <- dados_mapa_2024 %>% left_join(legenda_24 %>% select(Categoria, Cat_Legenda), by = "Categoria")
dados_mapa_2024$Cat_Legenda <- factor(dados_mapa_2024$Cat_Legenda, levels = legenda_24$Cat_Legenda)
cores_legenda <- setNames(c("#004383", "#2772B2", "#8FC3E5", "#FDBE84", "#E36F22", "#A03016", "#F3F3F3"), legenda_24$Cat_Legenda)

# Plotando o Mapa 2024
mapa_2024 <- ggplot() +
  geom_sf(data = dados_mapa_2024, aes(fill = Cat_Legenda), color = "grey90", size = 0.00000003) +
  geom_sf(data = estados_brasil, fill = NA, color = "grey30", size = 0.3) +
  scale_fill_manual(name = "Classificação IPS 2024", values = cores_legenda, drop = FALSE) +
  theme_void() +
  theme(legend.position = "right", legend.title = element_text(face = "bold", size = 16), legend.text = element_text(size = 14))

print(mapa_2024)

# --- 5. ANÁLISE COMPARATIVA E EVOLUÇÃO (2024-2025) ---
ips_comparativo <- ips_2024 %>%
  select(codigo_ibge, municipio, uf, ips_2024 = ips) %>%
  left_join(ips_2025 %>% select(codigo_ibge, ips_2025 = ips), by = "codigo_ibge") %>%
  mutate(variacao_ips = ips_2025 - ips_2024,
         destaque_ce = ifelse(uf == "CE", "Ceará", "Outros Estados"))

# Dispersão Quadrantes (Alto-Alto, Baixo-Baixo) com destaque para Ceará
media_x <- mean(ips_comparativo$ips_2024, na.rm = TRUE)
media_y <- mean(ips_comparativo$ips_2025, na.rm = TRUE)

ggplot(ips_comparativo, aes(x = ips_2024, y = ips_2025)) +
  geom_point(data = subset(ips_comparativo, destaque_ce == "Outros Estados"), aes(color = destaque_ce), alpha = 0.6, size = 4) +
  geom_point(data = subset(ips_comparativo, destaque_ce == "Ceará"), aes(color = destaque_ce), alpha = 0.6, size = 4) +
  geom_smooth(method = "lm", color = "black", se = FALSE, size = 2) +
  geom_hline(yintercept = media_y, linetype = "dashed", color = "grey15") +
  geom_vline(xintercept = media_x, linetype = "dashed", color = "grey15") +
  scale_color_manual(values = c("Ceará" = "darkorange", "Outros Estados" = "grey")) +
  labs(x = "IPS 2024", y = "IPS 2025", color = "Destaque:") +
  theme_bw(base_size = 18) +
  theme(legend.position = "bottom")

# Variação Média por Estado (2024-2025)
ips_comparativo %>%
  group_by(uf) %>%
  summarise(media_variacao = mean(variacao_ips, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(uf, media_variacao), y = media_variacao, fill = media_variacao)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = format(round(media_variacao, 2), decimal.mark = ",")), hjust = -0.1, size = 5) +
  coord_flip() +
  scale_fill_gradient2(low = "lightcoral", mid = "grey", high = "steelblue", midpoint = 0) +
  labs(x = "Estado (UF)", y = "Variação Média do IPS") +
  theme_bw(base_size = 18) + theme(legend.position = "none")