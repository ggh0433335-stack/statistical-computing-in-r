# Statistical Computing in R

A collection of three university coursework assignments exploring **probability simulation, statistical inference, and predictive modeling in R**. The exercises use Monte Carlo experiments and linear regression to examine how modeling assumptions affect statistical conclusions and prediction performance.

**Academic year:** 2026–2027  
**Language:** R

## Projects

### 1. Probability simulation: Modeling incident counts

**Script:** [`01-probability-simulation/poisson-incident-simulation.R`](01-probability-simulation/poisson-incident-simulation.R)

Uses a case study involving hospital incidents to compare two assumptions about event rates:

- A **fixed-rate Poisson model**, in which all nurses have the same underlying incident rate.
- A **heterogeneous-rate model**, in which nurse-specific rates are drawn from an exponential distribution before simulating Poisson incident counts.

Both models estimate the probability of observing at least 14 incidents in 203 shifts using **1,000,000 simulated observations**. The exercise illustrates why assumptions about variation between individuals matter when interpreting apparently rare events.

*Scope:* The shared script implements the Poisson simulations from Assignment 1; it does not include the assignment's separate estimator-comparison exercise.

### 2. Regression inference: Multicollinearity and heteroskedasticity

**Scripts:**
- [`02-regression-inference/multicollinearity-monte-carlo.R`](02-regression-inference/multicollinearity-monte-carlo.R)
- [`02-regression-inference/heteroskedasticity-robust-tests.R`](02-regression-inference/heteroskedasticity-robust-tests.R)

**Multicollinearity experiment**

- Simulates a linear regression with two correlated predictors.
- Varies sample size (*n* = 20 or 100) and predictor correlation (ρ = 0, 0.5, 0.9, or 0.99).
- Estimates the **bias, variance, and mean squared error (MSE)** of OLS regression coefficients across 10,000 repetitions per condition.

**Heteroskedasticity experiment**

- Compares additive (constant-variance) and multiplicative (predictor-dependent variance) noise.
- Evaluates conventional OLS t-tests against **HC3 heteroskedasticity-robust tests**.
- Estimates rejection rates under both the null hypothesis and an alternative across 10,000 repetitions per condition.

Together, these experiments explore the reliability of regression coefficient estimates and hypothesis tests when common statistical assumptions are weakened.

### 3. Housing-price prediction: Model selection and evaluation

**Script:** [`03-housing-model-selection/madrid-housing-model-selection.R`](03-housing-model-selection/madrid-housing-model-selection.R)

Builds and evaluates linear regression models for predicting **Madrid house prices** using property characteristics.

- Explores variables and applies log transformations to skewed measurements.
- Uses a **50% training / 25% validation / 25% test** split.
- Evaluates all **98 combinations of 1 to 4 predictors** from seven candidate features.
- Chooses the model with the lowest validation MSE, refits it on the training and validation data, and evaluates it on held-out test data.
- Reports test MSE and RMSE on the **log-price scale**.

**Data availability:** This script requires `madrid_houses_clean.csv`, which is not included in this repository. The data was provided for the course and originally sourced from a Madrid real estate dataset on Kaggle. Place a legally obtained copy in the **repository root** before running this script. Do not assume the code can run without this file.

## Repository structure

```text
statistical-computing-in-r/
├── README.md
├── .gitignore
├── 01-probability-simulation/
│   └── poisson-incident-simulation.R
├── 02-regression-inference/
│   ├── multicollinearity-monte-carlo.R
│   └── heteroskedasticity-robust-tests.R
└── 03-housing-model-selection/
    └── madrid-housing-model-selection.R
```

## How to run

Install [R](https://www.r-project.org/) and the required R packages:

```r
install.packages(c("MASS", "sandwich", "lmtest"))
```

From the repository root, run a script with `Rscript`:

```bash
Rscript 01-probability-simulation/poisson-incident-simulation.R
Rscript 02-regression-inference/multicollinearity-monte-carlo.R
Rscript 02-regression-inference/heteroskedasticity-robust-tests.R
Rscript 03-housing-model-selection/madrid-housing-model-selection.R
```

For the housing analysis, first make sure `madrid_houses_clean.csv` is in the root directory. The scripts use fixed random seeds to make their simulation procedures reproducible. The larger Monte Carlo experiments may take time to complete.

## Techniques demonstrated

`R` · `Monte Carlo simulation` · `Poisson distribution` · `OLS regression` · `Multicollinearity` · `Heteroskedasticity` · `HC3 robust standard errors` · `Train/validation/test split` · `Exhaustive feature subset selection` · `MSE / RMSE`

## Academic context

These scripts originated from coursework for **JBM050 Statistical Computing** during the 2026–2027 academic year. They are presented as an educational portfolio of applied statistical programming, not as independent research or production-ready software. The original assignments were designated group work; attribution and publication should follow course rules and collaborators' agreements.
