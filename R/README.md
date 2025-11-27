# R – KAUST Bioinformatics Bootcamp

This folder contains my R work for the KAUST Bioinformatics (Bi) Bootcamp.

At the moment, it includes the guided data analysis case study from **Module 2 – Introduction to Programming II (using R)**.

## Files

- `ADcaseStudy.R`  
  R script for the **Earth vs Venus gene expression** case study.

## Case study overview – Earth vs Venus gene expression

The goal of this case study is to analyse a simulated gene expression dataset and compare patients from two planets:

- **Earth**
- **Venus**

The main analysis steps implemented in `ADcaseStudy.R` are:

1. **Load the data**
   - Read the CSV file into R.
   - Convert the data to a numeric matrix.
   - Check for missing values.

2. **Explore the distribution**
   - Plot a histogram of the raw expression values.
   - Apply `log1p()` transformation to approximate a normal distribution.
   - Plot a histogram of the log-transformed data.

3. **Check normality for a single gene**
   - Use `qqnorm()` and `qqline()` for one gene on one planet.
   - Apply the Shapiro–Wilk test (`shapiro.test`) for Earth vs Venus samples.

4. **Principal Component Analysis (PCA)**
   - Run `prcomp()` on the log-transformed matrix.
   - Inspect the scree plot and cumulative variance.
   - Visualise sample separation by planet (Earth vs Venus) using `factoextra::fviz_pca_ind`.

5. **Differential expression (t-tests)**
   - For each gene, run a two-sample t-test comparing Earth vs Venus.
   - Collect p-values and count significantly different genes (e.g. p < 0.05).

6. **Visualisation of results**
   - Heatmap of significantly different genes using `pheatmap`.
   - Mean–variance plot for Earth samples.
   - Volcano plot combining fold change and p-values.

## How to run

1. Open the project folder in **RStudio**.
2. Make sure the CSV data file (e.g. `DATA_FSB_SET_4A.csv`) is in your working directory.
3. Open `ADcaseStudy.R`.
4. Install the required packages once:
   - `tidyverse`
   - `corrr`
   - `factoextra`
   - `pheatmap`
5. Source or run the script step by step to reproduce the plots and analysis.

