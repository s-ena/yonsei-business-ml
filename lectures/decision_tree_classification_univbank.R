rm(list = ls())

############## 1. Data Loading & Initial Inspection ##############

bank.df <- read.csv("./data/UniversalBank.csv", na.strings = "")
dim(bank.df)
head(bank.df)
str(bank.df)
colSums(is.na(bank.df))

##################### 2. Data Preprocessing #####################

bank.df$Personal.Loan <- factor(bank.df$Personal.Loan)
str(bank.df)

bank.df$Education <- factor(bank.df$Education)
bank.df$Securities.Account <- factor(bank.df$Securities.Account)
bank.df$CD.Account <- factor(bank.df$CD.Account)
bank.df$Online <- factor(bank.df$Online)
bank.df$CreditCard <- factor(bank.df$CreditCard)
head(bank.df)
summary(bank.df)

bank.df <- bank.df[, -c(1, 5)]
str(bank.df)
dim(bank.df)

###################### 3. Data Partitioning ######################

set.seed(1)
train.idx <- sample(c(1:dim(bank.df)[1]), dim(bank.df)[1] * 0.6)
train.df <- bank.df[train.idx, ]
dim(train.df)
valid.df <- bank.df[-train.idx, ]
dim(valid.df)

######################## 4. Decision Tree ########################

# ===================== 4-1. Generate Tree =====================

# install.packages("rpart")
library(rpart)

# install.packages("rpart.plot")
library(rpart.plot)

default.ct <- rpart(Personal.Loan ~ ., data = train.df, method = "class")
print(default.ct)

rpart.rules(default.ct)
rpart.rules(default.ct, extra = 4)

# ===================== 4-2. Tree Diagram =====================

prp(default.ct)
prp(default.ct, type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10)
prp(default.ct,
  type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10,
  box.col = ifelse(default.ct$frame$var == "<leaf>", "lightgreen", "white")
)

# ================== 4-3. Classify New Data ==================

new.df <- data.frame(
  Age = 55, Experience = 20, Income = 40, Family = 3, CCAvg = 6,
  Education = "2", Mortgage = 70, Personal.Loan = 1,
  Securities.Account = "1", CD.Account = "1", Online = "1",
  CreditCard = "1"
)

new.df
str(new.df)

predict(default.ct, new.df)
predict(default.ct, new.df, type = "class")

# ================= 4-4. Improve Tree Diagram =================

# install.packages("rattle")
library(rattle)
library(RColorBrewer)

fancyRpartPlot(default.ct)

###################### 5. Tree Manipulation ######################

# ==================== 5-1. Full Tree ====================

deeper.ct <- rpart(Personal.Loan ~ ., data = train.df, method = "class", cp = 0, minsplit = 1)
prp(deeper.ct,
  type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10,
  box.col = ifelse(default.ct$frame$var == "<leaf>", "lightgreen", "white")
)

# ==================== 5-1. Other Trees ====================

ploan.ct1 <- rpart(Personal.Loan ~ ., data = train.df, method = "class", maxdepth = 3)
prp(ploan.ct1,
  type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10,
  box.col = ifelse(default.ct$frame$var == "<leaf>", "lightgreen", "white")
)

ploan.ct2 <- rpart(Personal.Loan ~ ., data = train.df, method = "class", minbucket = 15)
prp(ploan.ct2,
  type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10,
  box.col = ifelse(default.ct$frame$var == "<leaf>", "lightgreen", "white")
)

######################### 6. Performance #########################

library(caret)

default.ct.point.pred.train <- predict(default.ct, train.df, type = "class")
head(default.ct.point.pred.train, n = 20)
class(default.ct.point.pred.train)
confusionMatrix(default.ct.point.pred.train, train.df$Personal.Loan, positive = "1")

default.ct.point.pred.valid <- predict(default.ct, valid.df, type = "class")
head(default.ct.point.pred.valid, n = 20)
class(default.ct.point.pred.valid)
confusionMatrix(default.ct.point.pred.valid, valid.df$Personal.Loan, positive = "1")

# using deeper.ct
deeper.ct.point.pred.train <- predict(deeper.ct, train.df, type = "class")
confusionMatrix(deeper.ct.point.pred.train, train.df$Personal.Loan)

deeper.ct.point.pred.valid <- predict(deeper.ct, valid.df, type = "class")
confusionMatrix(deeper.ct.point.pred.valid, valid.df$Personal.Loan)

###################### 7. ROC & Gain Chart ######################

# ======================= 7-1. ROC & AUC =======================

library(pROC)

pred.prob <- predict(default.ct, newdata = valid.df, type = "prob")
head(pred.prob, n = 10)

ROC_bank <- roc((ifelse(valid.df$Personal.Loan == "1", 1, 0)), pred.prob[, 2])
plot(ROC_bank, col = "lightblue")

auc(ROC_bank)

# ======================= 7-2. Gain Chart =======================

library(gains)

dim(valid.df)
head(pred.prob)

gain <- gains(ifelse(valid.df$Personal.Loan == "1", 1, 0), pred.prob[, 2], groups = 10)

plot(c(0, gain$cume.pct.of.total * sum(valid.df$Personal.Loan == "1")) ~ c(0, gain$cume.obs),
  xlab = "# cases", ylab = "Cumulative", main = "Lift Chart", type = "l"
)
lines(c(0, sum(valid.df$Personal.Loan == "1")) ~ c(0, dim(valid.df)[1]), lty = 1)
dim(valid.df)[1]

################# 8. Random Forest & Boosted Trees #################

# ======================= 8-1. Random Forest =======================

# install.packages("randomForest")
library(randomForest)

rf <- randomForest(Personal.Loan ~ ., data = train.df, ntree = 500, importance = TRUE)

varImpPlot(rf)
varImpPlot(rf, type = 1)
varImpPlot(rf, type = 2)

rf.pred <- predict(rf, valid.df)
head(rf.pred, n = 30)
confusionMatrix(rf.pred, valid.df$Personal.Loan)

# ======================= 8-2. Boosted Trees =======================

# install.packages("adabag")
library(adabag)

boost <- boosting(Personal.Loan ~ ., data = train.df)
bt.pred <- predict(boost, valid.df)
head(bt.pred$class, n = 20)
class(bt.pred$class)

confusionMatrix(factor(bt.pred$class), valid.df$Personal.Loan)
