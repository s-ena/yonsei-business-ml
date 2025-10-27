rm(list = ls())

############### 1. Data Loading & Initial Inspection ###############

install.packages("MASS")
library(MASS)

housing.df <- Boston
dim(housing.df)

sum(is.na(housing.df))
head(housing.df)
str(housing.df)
summary(housing.df)

####################### 2. Data Partitioning #######################

set.seed(42)
nrow(housing.df)
train.index <- sample(1:nrow(housing.df), 0.6 * nrow(housing.df))
train.df <- housing.df[train.index, ]
valid.df <- housing.df[-train.index, ]

train.norm.df <- train.df
valid.norm.df <- valid.df
housing.norm.df <- housing.df

######################## 3. Normalize Data ########################

library(caret)

# will normalize except for outcome variable
norm.values <- preProcess(train.df[, -14], method = c("center", "scale"))
train.norm.df[, -14] <- predict(norm.values, train.df[, -14])
head(train.norm.df)

valid.norm.df[, -14] <- predict(norm.values, valid.df[, -14])
head(valid.norm.df)

######################## 5. kNN Regression ########################

library(FNN)

# knn.reg
pred5 <- knn.reg(train = train.norm.df[, -14], test = valid.norm.df[, -14], y = train.norm.df[, 14], k = 5)
pred5

length(pred5$pred)
head(pred5$pred, n = 10)

length(valid.df$medv)

library(caret)
RMSE(pred5$pred, valid.df$medv) # predicted value, actual value

# alternatively, calculate directly
sqrt(mean((valid.df$medv - pred5$pred)^2))

# alternatively, use ModelMetrics package
ModelMetrics::rmse(pred5$pred, valid.df$medv)

######################## 6. With New Data ########################

new.rec <- data.frame(0.2, 0, 7.2, 0, 0.538, 6.3, 62, 4.7, 4, 307, 21, 10, 31)
new.rec
dim(new.rec)

names(train.norm.df)
names(new.rec) <- names(train.norm.df)[-14]
new.rec

new.norm.rec <- predict(norm.values, new.rec)
new.norm.rec

knn.pred <- knn.reg(train = train.norm.df[, -14], test = new.norm.rec, y = train.df$medv, k = 3)
knn.pred

############################ 7. Extra ############################

# make a categorical col for later Rapidminer practice
housing.df <- Boston
housing.new.df <- housing.df
head(housing.new.df)
median(housing.new.df$medv)
housing.new.df$range <- ifelse(housing.new.df$medv > median(housing.new.df$medv), "high", "low")
head(housing.new.df)
summary(factor(housing.new.df$range))

# row.names = FALSE => prevent row names to be written to file
write.csv(housing.new.df, "./basic/data/boston_housing_new.csv", row.names = FALSE)
