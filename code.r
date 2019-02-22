setwd("~/ACMworkshop2019")

## testing that R works

install.packages("mlbench")
library(mlbench)

# ------------------------------------------------------------------------------------- #
## BOSTON HOUSING MARKET
## Simple Linear Regression
# We will predict Boston Housing prices

# load data set from mlbench library
data=BostonHousing
#view data
View(data)
# what are our variables?
?BostonHousing
# it's good practice to explore with plots!
# Always make pairwise scatterplots, with ggpairs()
# Correlation plots are useful too, with ggcorr()
# these functions are from the GGally library

install.packages("ggplot2")
install.packages("GGally")
library(ggplot2)
library(GGally)

ggpairs(data)
ggcorr(data)

# lstat is the percentage of lower status of the population
# maybe that would be a good predictor?

# lm(response~predictor,data=...)
# our outcome is medv, the median value of homes in USD 1000's

lin_reg=lm(medv~lstat,data=data)

# summary() gives our coefficients, residuals, and test statistics

summary(lin_reg)

# plot our line of best fit on our data

plot(data$lstat,data$medv,pch=20)
abline(lin_reg,col="red")

# residual plots
# plot(your lm() function)

plot(lin_reg)

# ------------------------------------------------------------------------------------- #

## Multiple Linear Regression

# lm(response~predictor1+predictor2+...+predictork, data=...) for just a subset of predictors

lin_reg2=lm(medv~lstat+rm,data=data)
summary(lin_reg2)
plot(lin_reg2)

# lm(response~., data=...) to include ALL predictors in the data set

lin_reg3=lm(medv~.,data=data)
summary(lin_reg3)
plot(lin_reg3)

# ------------------------------------------------------------------------------------- #

## Train/Test Split

# R will randomly draw samples
# set.seed() ensures that if someone else were to use this, they would get that same 
# randomly-generated sample
set.seed(2)

# I want 25% of my observations to be testing data
ratio=sample(nrow(data),nrow(data)/4) #126 observations for testing
training=data[-ratio,] #380 observations for training
test=data[ratio,]

# fitting simple linear regression model with training data
lin_reg4=lm(medv~lstat,data=training)
# assessing model with the test data
lin.pred=predict(lin_reg4,test)

# calculate root mean square error (std devtn of residuals)
RMSE=sqrt(mean((test$medv-lin.pred)^2))
# and our root mean square error is...
RMSE

# ------------------------------------------------------------------------------------- #

## k-Fold Cross Validation

install.packages("caret")
library(caret)

train_control=trainControl(method="cv",number=10)
k_fold=train(medv~lstat,data=data,trControl=train_control)
print(k_fold)
  
# ------------------------------------------------------------------------------------- #

## Leave One Out Cross Validation (LOOCV)
# WE WILL NOT RUN THIS IT WILL TAKE A LONG TIME
# Computationally eXpEnSiVe

train_control=trainControl(method="LOOCV")
loocv=train(medv~lstat,data=data,trControl=train_control)
print(loocv)

# ------------------------------------------------------------------------------------- #

## Ridge Regression

install.packages("glmnet")
library(glmnet)

# create model matrices for training and test sets

train.mat=model.matrix(medv~lstat,data=training)
test.mat=model.matrix(medv~lstat,data=test)

# set range of hyperparemeter values
# lambda from 10^10 to 10^-2
lambdas=10^seq(10,-2,length=100)

ridge=glmnet(train.mat,training$medv,alpha=0,lambda=lambdas)

# cross-validation to find the best hyperparameter values
ridge.cv=cv.glmnet(train.mat,training$medv,alpha=0,lambda=lambdas)

best_lambda=ridge.cv$lambda.min
best_lambda

# compute the test error

ridge.pred=predict(ridge,test.mat,alpha=0,s=best_lambda)
ridge.RMSE=sqrt(mean((test$medv-ridge.pred)^2))
ridge.RMSE

# ------------------------------------------------------------------------------------- #

## Lasso
# follows the same workflow as above
# just change all alpha from 0 to 1 in glmnet() functions

lasso=glmnet(train.mat,training$medv,alpha=1,lambda=lambdas)

# cross-validation to find the best hyperparameter values
lasso.cv=cv.glmnet(train.mat,training$medv,alpha=1,lambda=lambdas)

best_lambda=ridge.cv$lambda.min
best_lambda

# compute the test error

lasso.pred=predict(ridge,test.mat,alpha=1,s=best_lambda)
lasso.RMSE=sqrt(mean((test$medv-ridge.pred)^2))
lasso.RMSE

# ------------------------------------------------------------------------------------- #

## TITANIC SURVIVAL PREDICTION
## Logistic Regression

# import data from "titanic" library
install.packages("titanic")
library(titanic)
data=titanic_train #891 observations
# set up train/test split ratio
set.seed(10)
train=sample(nrow(data),3*nrow(data)/4)
#668 observations to train
#223 observations to test

# glm(Response~Predictor,data=...,family=binomial,subset=train)

log_reg=glm(Survived~Age,data=data,family=binomial,subset=train)

# cross-validation

test=data[-train,]
# create vector of probabilities
prob=predict(log_reg,type="response",test)
# create vector of "Did Not Survive" with the same number of rows as test set
predict=rep("Did Not Survive",nrow(test))
# replace "Did Not Survive" to "Survived" if probability exceeded 0.5
predict[prob>0.5]="Survived"
# Confusion matrix
table(predict,test$Survived)
  
# logistic regression with a dummy variable

data$Sex <- ifelse(data$Sex == "male", 1, 0)
# male --> 1
# female --> 0

log_reg2=glm(Survived~Age+Sex,data=data,family=binomial,subset=train)
test=data[-train,]
prob=predict(log_reg2,type="response",test)
predict=rep("Did Not Survive",nrow(test))
predict[prob>0.5]="Survived"
# Confusion matrix
table(predict,test$Survived)

