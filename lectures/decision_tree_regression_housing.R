rm(list = ls())

############## 1. Data Loading & Initial Inspection ##############

# install.packages("MASS")
library(MASS)

housing.df <- Boston
dim(housing.df)
sum(is.na(housing.df))
head(housing.df)
str(housing.df)
summary(housing.df)

###################### 2. Data Partitioning ######################

set.seed(42)
nrow(housing.df)

train.idx <- sample(1:nrow(housing.df), 0.6 * nrow(housing.df))

train.df <- housing.df[train.idx, ]
valid.df <- housing.df[-train.idx, ]

####################### 3. Regression Tree #######################

# ===================== 3-1. Generate Tree =====================

library(rpart)
library(rpart.plot)

default.rt <- rpart(medv ~ ., method = "anova", data = train.df)

print(default.rt)
rpart.rules(default.rt)

# ===================== 3-2. Tree Diagram =====================

prp(default.rt)
prp(default.rt, type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10)
prp(default.rt,
  type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10,
  box.col = ifelse(default.rt$frame$var == "<leaf>", "lightgreen", "white")
)

png(file = "boston_housing.png", width = 600, height = 600)
prp(default.rt,
  type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10,
  box.col = ifelse(default.rt$frame$var == "<leaf>", "lightgreen", "white")
)
dev.off()

######################## 4. Performance ########################

pred.train <- predict(default.rt, train.df)
head(pred.train, n = 10)

pred.valid <- predict(default.rt, valid.df)
head(pred.valid, n = 10)

# install.packages("Metrics")
library(Metrics)

rmse(actual = train.df$medv, predicted = pred.train)
rmse(actual = valid.df$medv, predicted = pred.valid)

# alternatively
sqrt(mean((train.df$medv - pred.train)^2))
sqrt(mean((valid.df$medv - pred.valid)^2))

library(caret)

# alternatively
RMSE(obs = train.df$medv, pred = pred.train)
RMSE(obs = valid.df$medv, pred = pred.valid)
