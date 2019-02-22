## testing that R works

install.packages("ISLR")
install.packages("mlbench")
library(ISLR)
library(mlbench)

# ------------------------------------------------------------------------------------- #

## Simple Linear Regression
# We will predict Boston Housing prices

# load data set from mlbench library
data=BostonHousing
#view data
View(data)
# what are our variables?
?BostonHousing

# rm is number of rooms in home
# maybe that would be a good predictor?

# lm(response~predictor,data=...)
# our outcome is medv, the median value of homes in USD 1000's

lin_reg=lm(medv~rm,data=data)

# summary() gives our coefficients, residuals, and test statistics

summary(lin_reg)

# plot our line of best fit on our data

plot(data$rm,data$medv)
abline(lin_reg)

# residual plots
# plot(your lm() function)

plot(lin_reg)

# ------------------------------------------------------------------------------------- #

## Multiple Linear Regression

# lm(response~predictor1+predictor2+...+predictork, data=...) for just a subset of predictors

# lm(response~., data=...) to include ALL predictors in the data set

# ------------------------------------------------------------------------------------- #

## Ridge Regression

# ------------------------------------------------------------------------------------- #

## Lasso

# ------------------------------------------------------------------------------------- #

## Logistic Regression

# ------------------------------------------------------------------------------------- #

## Train/Test Split

# ------------------------------------------------------------------------------------- #

## k-Fold Cross Validation

# ------------------------------------------------------------------------------------- #

## Leave One Out Cross Validation (LOOCV)

