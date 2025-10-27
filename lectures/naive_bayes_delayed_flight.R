rm(list = ls())

############## 1. Data Loading & Initial Inspection ##############

# Download "FlightDelays.csv"
# Load the file in the data frame format

delays.df <- read.csv("./basic/data/FlightDelays.csv", na.strings = "")
str(delays.df)

# examine the file with some commands learned in R Baiscs session
dim(delays.df)
head(delays.df, n = 10)
View(delays.df)

colSums(is.na(delays.df))
sum(is.na(delays.df))

str(delays.df)
summary(delays.df)

##################### 2. Data Preprocessing #####################

# ================= 2-1. Categorical Conversion =================

# install and load a package for naive bayes
# install.packages("e1071")
library(e1071)

# change numerical variables to categorical variables first
class(delays.df$DAY_WEEK)
summary(delays.df$DAY_WEEK)
delays.df$DAY_WEEK <- factor(delays.df$DAY_WEEK)

class(delays.df$DAY_WEEK)
levels(delays.df$DAY_WEEK)
summary(delays.df$DAY_WEEK)

# change character variables to categorical variables
delays.df$ORIGIN <- factor(delays.df$ORIGIN)
delays.df$DEST <- factor(delays.df$DEST)
delays.df$CARRIER <- factor(delays.df$CARRIER)

delays.df$Flight.Status <- factor(delays.df$Flight.Status)

str(delays.df)
summary(delays.df)

delays.df$CRS_DEP_TIME <- factor(round((delays.df$CRS_DEP_TIME + 20) / 100))
View(delays.df)

class(delays.df$CRS_DEP_TIME)
str(delays.df$CRS_DEP_TIME)
levels(delays.df$CRS_DEP_TIME)
summary(delays.df$CRS_DEP_TIME)

str(delays.df)

# ================= 2-2. Date Variable Processing =================

# Use 'lubridate' package to work with dates
# install.packages("lubridate")
library(lubridate)

class(delays.df$FL_DATE)
head(delays.df$FL_DATE)
tail(delays.df$FL_DATE)

delays.df$FL_DATE2 <- mdy(delays.df$FL_DATE)
str(delays.df)
head(delays.df$FL_DATE2)
class(delays.df$FL_DATE2)

delays.df$day <- day(delays.df$FL_DATE2)
str(delays.df)
head(delays.df$day)
class(delays.df$day)

delays.df$month <- month(delays.df$FL_DATE2)
delays.df$year <- year(delays.df$FL_DATE2)

str(delays.df)
head(delays.df$year)
class(delays.df$year)

# look at the first 6 rows of delays.df
head(delays.df)

####################### 3. Data Partitioning #######################

# we will be using only five predictors(10,1,8,4,2) and one outcome var(13)
selected.var <- c("DAY_WEEK", "CRS_DEP_TIME", "ORIGIN", "DEST", "CARRIER", "Flight.Status")
dim(delays.df)

# create training and validation data sets
dim(delays.df)[1] # to see how many rows in the date frame, here 2201 rows

set.seed(2)

# randomly pick 1320(=2201*0.6) numbers from a range 1 to 2201
train.index <- sample(c(1:dim(delays.df)[1]), dim(delays.df)[1] * 0.6)
head(train.index)

train.df <- delays.df[train.index, selected.var]
dim(train.df)
head(train.df)

valid.df <- delays.df[-train.index, selected.var] # exclude train.index
dim(valid.df)
head(valid.df)

############ 4. Naive Bayes Model Training & Prediction ############

# ========================= 4-1. Training =========================

# run naive bayes
# of the variable in train.df, use Flight.Status as an outcome,
# and use all the others as predictors "."
# to use a subset of variables as predictor, list var combined with "+" not "."
delays.nb <- naiveBayes(Flight.Status ~ ., data = train.df)
delays.nb

# use prop.table() with margin=1 to convert a count table to a proportion table,
# where each row sums up to 1 (use margin=2 for column sums)
# this proportion table is the same as the last part of the output of delays.nb
table(train.df$Flight.Status, train.df$DEST)
prop.table(table(train.df$Flight.Status, train.df$DEST), margin = 1)

# =============== 4-2. Prediction on Validation data ===============

# predict probabilities
# if type="raw", the conditional a-posterior probabilities, p(y|x1,x2,...)
# for each class are returned, and the class with maximal probability else
pred.prob <- predict(delays.nb, newdata = valid.df, type = "raw")
head(pred.prob, n = 10)
round(head(pred.prob, n = 10), 2)

class(pred.prob)
dim(pred.prob)
dim(valid.df)

pred.class <- predict(delays.nb, newdata = valid.df)

head(pred.class, n = 10)
class(pred.class)

# create a table with actual class, predicted class and predicted probabilities
df <- data.frame(actual = valid.df$Flight.Status, predicted = pred.class, pred.prob)
head(df, n = 10)

dim(df)

# to report actual and predicted probabilities/classes of certain records in the valid.df
# the code below will choose rows satisfying the criteria
df[valid.df$CARRIER == "DL" & valid.df$DAY_WEEK == 7 & valid.df$CRS_DEP_TIME == 10 & valid.df$DEST == "LGA" & valid.df$ORIGIN == "DCA", ]

# =================== 4-3. New Record Prediction ===================

# to report predicted probabilities/classes of certain records in the future,
# not from the valid.df
# of course, new data may come from a .csv file
new.record1.df <- data.frame(CARRIER = "DL", DAY_WEEK = 5, CRS_DEP_TIME = 15, DEST = "LGA", ORIGIN = "DCA")
new.record1.df
str(new.record1.df)

new.record1.df$CARRIER <- factor(new.record1.df$CARRIER)
new.record1.df$DEST <- factor(new.record1.df$DEST)
new.record1.df$ORIGIN <- factor(new.record1.df$ORIGIN)
new.record1.df$DAY_WEEK <- factor(new.record1.df$DAY_WEEK)
new.record1.df$CRS_DEP_TIME <- factor(new.record1.df$CRS_DEP_TIME)
str(new.record1.df)

pred.prob.new.record1 <- predict(delays.nb, newdata = new.record1.df, type = "raw")
pred.prob.new.record1

pred.class.new.record1 <- predict(delays.nb, newdata = new.record1.df)
pred.class.new.record1 # ontime

################## 5. Model Performance Evaluation ##################

# ========================= 5-1. ROC & AUC =========================

# ROC and AUC
# install.packages("pROC")
library(pROC)

head(valid.df, n = 10)

ROC_flight <- roc((ifelse(valid.df$Flight.Status == "delayed", 1, 0)), pred.prob[, 1])
plot(ROC_flight, col = "lightblue")

auc(ROC_flight)

# ========================= 5-2. Gain Chart =========================

# gain(=lift) chart
# install.packages("gains")
library(gains)

dim(valid.df)
head(pred.prob)
head(pred.class)

# to create a gain chart, we first need to create an object based on gains()
gain <- gains(ifelse(valid.df$Flight.Status == "delayed", 1, 0), pred.prob[, 1], groups = 10)

# ?gains
# gain$cume.pct.of.total tells us the percentage
gain

# be careful, should be "~" not "-", should be "l" not "1"
# if replace "l" by "p", will find the dotted line

sum(valid.df$Flight.Status == "delayed")
sum(valid.df$Flight.Status == "ontime")
dim(valid.df)[1]

options(digits = 2)
gain$cume.pct.of.total
gain$cume.obs

# use as a template
plot(c(0, gain$cume.pct.of.total * sum(valid.df$Flight.Status == "delayed")) ~ c(0, gain$cume.obs), xlab = "# cases", ylab = "Cumulative", main = "Lift Chart", type = "l")

# use as a template
# lines(c(0,168)~c(0,881), lty=1)
lines(c(0, sum(valid.df$Flight.Status == "delayed")) ~ c(0, dim(valid.df)[1]), lty = 1)
dim(valid.df)[1]

# to change the line type
lines(c(0, sum(valid.df$Flight.Status == "delayed")) ~ c(0, dim(valid.df)[1]), lty = 2)

# ====================== 5-3. Confusion Matrix ======================

# for confusion matrix
# install.packages("caret")
library(caret)

delays.nb

pred.class <- predict(delays.nb, newdata = train.df)
pred.class

confusionMatrix(pred.class, train.df$Flight.Status)

pred.class <- predict(delays.nb, newdata = valid.df)
confusionMatrix(pred.class, valid.df$Flight.Status)

# to change a cutoff value, set a new threshold value = 0.3
# overall accuracy를 희생해서 sensitivity 올리기 (cutoff ↓)
pred.probth <- factor(ifelse(pred.prob[, 1] >= 0.3, "delayed", "ontime"))
class(pred.probth)

confusionMatrix(pred.probth, valid.df$Flight.Status)
