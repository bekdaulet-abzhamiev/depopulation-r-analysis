############################################################
# DEMOGRAPHIC DECLINE ANALYSIS (PANEL DATA)
# Author: R Studio Project
# Purpose: investigate structural determinants of TFR
############################################################

# -------------------------------
# 0. PACKAGES
# -------------------------------

library(WDI)
library(dplyr)
library(ggplot2)
library(plm)
library(lmtest)
library(sandwich)
library(car)

# -------------------------------
# 1. DATA DOWNLOAD (WORLD BANK)
# -------------------------------

depop_data <- WDI(
  country = "all",
  indicator = c(
    tfr = "SP.DYN.TFRT.IN",
    infant_mortality = "SP.DYN.IMRT.IN",
    life_exp = "SP.DYN.LE00.IN",
    urbanization = "SP.URB.TOTL.IN.ZS",
    gdp_ppp = "NY.GDP.PCAP.PP.CD",
    female_lfp = "SL.TLF.CACT.FE.ZS"
  ),
  start = 1990,
  end = 2024
)

# -------------------------------
# 2. CLEANING DATA
# -------------------------------

depop_clean <- depop_data %>%
  filter(!is.na(iso3c)) %>%
  filter(!country %in% c("World"))

# -------------------------------
# 3. TRANSFORMATION
# -------------------------------

depop_clean$log_gdp <- log(depop_clean$gdp_ppp)

plot_data <- na.omit(depop_clean)

# -------------------------------
# 4. SAVE DATASETS
# -------------------------------

write.csv(depop_clean, "depop_clean.csv", row.names = FALSE)
saveRDS(depop_clean, "depop_clean.rds")
saveRDS(plot_data, "plot_data_final.rds")

# -------------------------------
# 5. PANEL STRUCTURE
# -------------------------------

panel_data <- pdata.frame(plot_data, index = c("country", "year"))
saveRDS(panel_data, "panel_data.rds")

# -------------------------------
# 6. OLS MODELS (BASELINE)
# -------------------------------

model_h1 <- lm(tfr ~ urbanization, data = plot_data)
model_h2 <- lm(tfr ~ log_gdp, data = plot_data)
model_h3 <- lm(tfr ~ female_lfp, data = plot_data)
model_h4 <- lm(tfr ~ life_exp, data = plot_data)
model_h5 <- lm(tfr ~ infant_mortality, data = plot_data)

saveRDS(model_h1, "model_h1.rds")
saveRDS(model_h2, "model_h2.rds")
saveRDS(model_h3, "model_h3.rds")
saveRDS(model_h4, "model_h4.rds")
saveRDS(model_h5, "model_h5.rds")

# -------------------------------
# 7. PANEL MODELS
# -------------------------------

pooled_model <- plm(
  tfr ~ urbanization + log_gdp + female_lfp + life_exp + infant_mortality,
  data = panel_data,
  model = "pooling"
)

fe_model <- plm(
  tfr ~ urbanization + log_gdp + female_lfp + life_exp + infant_mortality,
  data = panel_data,
  model = "within"
)

re_model <- plm(
  tfr ~ urbanization + log_gdp + female_lfp + life_exp + infant_mortality,
  data = panel_data,
  model = "random"
)

saveRDS(pooled_model, "pooled_model.rds")
saveRDS(fe_model, "fe_model.rds")
saveRDS(re_model, "re_model.rds")

# -------------------------------
# 8. HAUSMAN TEST
# -------------------------------

hausman_test <- phtest(fe_model, re_model)
saveRDS(hausman_test, "hausman_test.rds")

# -------------------------------
# 9. ROBUST FE ESTIMATES
# -------------------------------

fe_robust <- coeftest(fe_model, vcov = vcovHC(fe_model, type = "HC1"))
saveRDS(fe_robust, "fe_robust_results.rds")

# -------------------------------
# 10. VISUALIZATION
# -------------------------------

dir.create("plots", showWarnings = FALSE)

panel_trend_tfr <- ggplot(plot_data, aes(x = year, y = tfr)) +
  stat_summary(fun = mean, geom = "line") +
  ggtitle("Global TFR Trend")

panel_urbanization <- ggplot(plot_data, aes(x = urbanization, y = tfr)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm")

panel_gdp <- ggplot(plot_data, aes(x = log_gdp, y = tfr)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm")

panel_female_lfp <- ggplot(plot_data, aes(x = female_lfp, y = tfr)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm")

panel_life_exp <- ggplot(plot_data, aes(x = life_exp, y = tfr)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm")

panel_infant_mortality <- ggplot(plot_data, aes(x = infant_mortality, y = tfr)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = "lm")

ggsave("plots/trend_tfr.png", panel_trend_tfr)
ggsave("plots/urbanization.png", panel_urbanization)
ggsave("plots/gdp.png", panel_gdp)
ggsave("plots/female_lfp.png", panel_female_lfp)
ggsave("plots/life_exp.png", panel_life_exp)
ggsave("plots/infant_mortality.png", panel_infant_mortality)

# -------------------------------
# 11. DIAGNOSTICS
# -------------------------------

vif(fe_model)

# -------------------------------
# 12. SAVE FULL SESSION
# -------------------------------

save.image("final_analysis.RData")

############################################################
# END OF ANALYSIS
############################################################