## testing that R works

install.packages("ISLR")
library(ISLR)

## Simple Linear Regression

# lm(response~predictor,data=...)

# summary() gives our coefficients, residuals, and test statistics

# plot our line of best fit on our data

data(car)

# ------------------------------------------------------------------------------------- #

## Multiple Linear Regression

# lm(response~predictor1+predictor2+...+predictork, data=...) for just a subset of predictors

# lm(response~., data=...) to include ALL predictors in the data set

# ------------------------------------------------------------------------------------- #

## Logistic Regression
