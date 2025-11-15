# Question 1
inn.df <- read.csv("./data/INNHotelsGroup.csv", na.strings = "")
dim(inn.df)

# Question 2
colSums(is.na(inn.df))

# Question 3
inn.df <- subset(inn.df, select = -Booking_ID)
str(inn.df)

# Question 4
inn.df$type_of_meal_plan <- factor(inn.df$type_of_meal_plan)
inn.df$room_type_reserved <- factor(inn.df$room_type_reserved)
inn.df$market_segment_type <- factor(inn.df$market_segment_type)
inn.df$booking_status <- factor(inn.df$booking_status)
str(inn.df)

# Question 5
set.seed(1)

train.idx <- sample(c(1:dim(inn.df)[1]), dim(inn.df)[1] * 0.6)
train.df <- inn.df[train.idx, ]
valid.df <- inn.df[-train.idx, ]

dim(train.df)
dim(valid.df)

# Question 6
library(rpart)
library(rpart.plot)

default.ct <- rpart(booking_status ~ ., data = train.df, method = "class")
prp(default.ct,
  type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
  box.col = ifelse(default.ct$frame$var == "<leaf>", "gray", "white")
)

# Question 7
library(caret)

default.ct.point.pred.train <- predict(default.ct, train.df, type = "class")
default.ct.point.pred.valid <- predict(default.ct, valid.df, type = "class")

confusionMatrix(default.ct.point.pred.train, train.df$booking_status, positive = "Canceled")
confusionMatrix(default.ct.point.pred.valid, valid.df$booking_status, positive = "Canceled")

# Question 8
smaller.ct <- rpart(booking_status ~ ., data = train.df, method = "class", minbucket = 20, maxdepth = 4)
prp(smaller.ct,
  type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
  box.col = ifelse(smaller.ct$frame$var == "<leaf>", "gray", "white")
)

# Question 9
smaller.ct.point.pred.train <- predict(smaller.ct, train.df, type = "class")
smaller.ct.point.pred.valid <- predict(smaller.ct, valid.df, type = "class")

confusionMatrix(smaller.ct.point.pred.train, train.df$booking_status, positive = "Canceled")
confusionMatrix(smaller.ct.point.pred.valid, valid.df$booking_status, positive = "Canceled")

# Question 10
rpart.rules(smaller.ct)

# Question 11
library(randomForest)

rf <- randomForest(booking_status ~ ., data = train.df, ntree = 300, importance = TRUE)
rf.pred <- predict(rf, valid.df)

confusionMatrix(rf.pred, valid.df$booking_status, positive = "Canceled")

# Question 12
varImpPlot(rf, type = 1)
