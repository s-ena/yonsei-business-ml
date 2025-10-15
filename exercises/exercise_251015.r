# 0
delays_ex.df <- read.csv("./basic/data/FlightDelays.csv")

# 1
dim(delays_ex.df)

# 2
head(delays_ex.df, n = 10)

# 3
summary(delays_ex.df)

# 4
colSums(is.na(delays_ex.df))

# 5
library(lubridate)
delays_ex.df$FL_DAY <- day(mdy(delays_ex.df$FL_DATE))
delays_ex.df$PR_Month <- ifelse(delays_ex.df$FL_DAY <= 10, "early", ifelse(delays_ex.df$FL_DAY <= 20, "mid", "late"))

# 6
delays_ex.df$PR_Month <- factor(delays_ex.df$PR_Month)
summary(delays_ex.df)

# 7
delays_ex.df$CRS_DEP_TIME_BIN <- factor(floor(delays_ex.df$CRS_DEP_TIME / 100))
summary(delays_ex.df)

# 8
delays_ex.df$DAY_WEEK <- factor(delays_ex.df$DAY_WEEK)
delays_ex.df$ORIGIN <- factor(delays_ex.df$ORIGIN)
delays_ex.df$Weather <- factor(delays_ex.df$Weather)
delays_ex.df$Flight.Status <- factor(delays_ex.df$Flight.Status)

# 9
summary(delays_ex.df)

# 10
selected_var <- c("DAY_WEEK", "CRS_DEP_TIME_BIN", "ORIGIN", "Weather", "PR_Month", "Flight.Status")

# 11
set.seed(2)

train.index <- sample(c(1:dim(delays_ex.df)[1]), size = dim(delays_ex.df)[1] * 0.7)
train.df <- delays_ex.df[train.index, selected_var]
valid.df <- delays_ex.df[-train.index, selected_var]

dim(train.df)
head(train.df)

dim(valid.df)
head(valid.df)

# 12
library(e1071)
delays_ex.nb <- naiveBayes(Flight.Status ~ ., data = train.df)

# 13
pred.prob <- predict(delays_ex.nb, newdata = valid.df, type = "raw")
pred.class <- predict(delays_ex.nb, newdata = valid.df)

df <- data.frame(actual = valid.df$Flight.Status, predicted_prob = pred.prob, predicted_class = pred.class)
head(df, n = 10)

# 14
df[valid.df$DAY_WEEK == 1 & valid.df$CRS_DEP_TIME_BIN == 8 & valid.df$ORIGIN == "DCA" & valid.df$Weather == 0 & valid.df$PR_Month == "early", ]

# 15
new.df <- data.frame(DAY_WEEK = c(1, 5), CRS_DEP_TIME_BIN = c(3, 5), ORIGIN = c("DCA", "IAD"), Weather = c(0, 1), PR_Month = c("early", "late"))
new.df

# 16
new.df[] <- lapply(new.df, factor)

pred.prob.new.df <- predict(delays_ex.nb, newdata = new.df, type = "raw")
pred.class.new.df <- predict(delays_ex.nb, newdata = new.df)

data.frame(predicted_prob = pred.prob.new.df, predicted_class = pred.class.new.df)

# 17
library(pROC)
ROC_flight <- roc((ifelse(valid.df$Flight.Status == "delayed", 1, 0)), pred.prob[, 1])
plot(ROC_flight, col = "lightblue")
auc(ROC_flight)

# 18
library(gains)
gain <- gains(ifelse(valid.df$Flight.Status == "delayed", 1, 0), pred.prob[, 1], groups = 10)
gain

# 19
library(caret)
pred.class <- predict(delays_ex.nb, newdata = train.df)
confusionMatrix(pred.class, train.df$Flight.Status)

# 20
pred.class <- predict(delays_ex.nb, newdata = valid.df)
confusionMatrix(pred.class, valid.df$Flight.Status)
