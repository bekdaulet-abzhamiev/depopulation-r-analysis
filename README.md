# depopulation-r-analysis
Econometric panel data analysis (1990–2024) implemented in R Studio to investigate global depopulation trends and structural determinants of fertility decline based on World Bank data.

---

This repository contains the complete replication code, econometric models, and data processing pipelines developed in **R Studio** for the research paper on global depopulation trends and fertility determinants. 

---

## 📊 Project Overview
The study investigates the fundamental structural causes of the modern demographic crisis, depopulation, and social atomization. Using macro-level **World Bank panel data**, it models the key factors driving the Total Fertility Rate (TFR) below the critical replacement level of 2.1.

### 🧠 Core Research Hypotheses Tested:
1. **Hypothesis 1 (Infant Mortality):** The reduction in infant mortality shifts reproductive strategies from "quantity" to "quality" of children.
2. **Hypothesis 2 (Urbanization):** Rapid urbanization structurally increases the economic and logistical costs of child-rearing.
3. **Hypothesis 3 (Female Empowerment):** Higher female education and labor force participation alter family planning horizons and fertility timing.
4. **Hypothesis 4 (Life Expectancy):** The general increase in life expectancy changes long-term socio-economic planning and career prioritization.
5. **Hypothesis 5 (Individualism):** Shifting cultural values toward individualism reduce individual incentives for traditional family formation.

---

## 🛠️ Tech Stack & Methodology
* **Language:** R (v4.x)
* **Environment:** R Studio
* **Model Specification:** Panel Data Econometric Model with **Fixed Effects (FE)** to control for time-invariant country-specific unobserved heterogeneity.
* **Diagnostics:** Pooled OLS, Random Effects, and **Hausman Specification Test** to statistically justify the choice of the FE model.
* **Data Source:** World Bank World Development Indicators (WDI) API.

---

## 📂 Repository Structure
All core project files are located in the root directory for direct integration with R Studio:

* `Analysis of the demographic situation and...Rproj` — R Studio project configuration file.
* `analysis.R` — Main script containing data preprocessing, exploratory data analysis, visualization, and econometric modeling.
* `depop_data_raw.csv` — Raw statistical indicators directly extracted from the World Bank.
* `depop_clean.csv` — Cleaned dataset with treated missing values and normalized variables.
* `panel_data.rds` — Processed data structured as an R panel data object (`pdata.frame`).
* `plot_data_final.csv` — Filtered dataset optimized specifically for visualization pipelines.
* `model_h1.rds` to `model_h5.rds` — Serialized R objects containing individual regression models for Hypotheses 1–5.
* `fe_model.rds` / `re_model.rds` / `pooled_model.rds` — Full econometric models (Fixed Effects, Random Effects, and Pooled OLS).
* `hausman_test.rds` — Saved results of the Hausman test.
* `renv.lock` — Dependency lockfile tracking the exact R package versions used (ensures reproducibility).
* `/plots` — Directory containing generated high-resolution visualizations (Figures 1–6) used in the paper.

---

## 🚀 How to Reproduce the Analysis

### 1. Prerequisites
Ensure you have **R** and **R Studio** installed. You will need the following key R libraries: `plm`, `ggplot2`, `dplyr`, `tidyr`, `lmtest`, and `sandwich` (for robust standard errors).

### 2. Execution Step-by-Step
1. Clone this repository or download it as a ZIP archive.
2. Open the `Analysis of the demographic situation and...Rproj` file in R Studio. This automatically sets the correct working directory.
3. (Optional) Run `renv::restore()` in the console to automatically install the exact package versions from `renv.lock`.
4. Open and run the `analysis.R` script sequentially to execute data parsing, model estimation, and chart generation.

---

## 📄 Academic Preprint & Author Info
The academic text detailing the theoretical framework, literature review, and comprehensive interpretation of these models is published as an open-access preprint.

* **Author:** Bekdaulet Abzhamiev (Independent Researcher)
* **ORCID Profile:** [https://orcid.org/0009-0003-4999-1861](https://orcid.org/0009-0003-4999-1861)
* **Contact Email:** b.r.abzhamiev@gmail.com

---
*Disclaimer: AI tools (Gemini) were utilized strictly for academic writing style enhancement, text editing, and R code syntax optimization.*
