# matrix and array
x2 <- matrix(c(1:12), ncol = 2)
x2

class(x2)

x2[2, 1]
x2[, 1]

mean(x2[, 1])
mean(x2[, 2])

rowMeans(x2)
apply(x2, 1, mean) # mean of each row
apply(x2, 1, sum) # mean of each row

mean(x2[1, ])
mean(x2[2, ])

colMeans(x2)
apply(x2, 2, mean)

# array
x3 <- array(c(1:30), dim = c(2, 5, 3)) # 3 2x5 matrix
x3

class(x3)

# list
x11 <- list(c(5, 4, 1), c("john", "nick", "sally"))
x11

class(x11)

x12 <- list(x11, x2, x3)
x12

class(x12)

# data frame
d <- c(1, 2, 3, 4)
e <- c("red", "white", "red", NA)
f <- c(TRUE, TRUE, TRUE, FALSE)

mydata <- data.frame(d, e, f)
mydata

class(mydata)
str(mydata)

class(mydata[, 1])
class(mydata[, 2])

mydata
mydata5 <- data.frame(d, e, f, stringsAsFactors = TRUE)
str(mydata5)
class(mydata5[, 2])

names(mydata)
names(mydata) <- c("ID", "Color", "Passed")

row.names(mydata)
row.names(mydata) <- c("s1", "s2", "s3", "s4")

mydata

mydata1 <- data.frame(d = c(1, 2, 3, 4), e = c("red", "white", "red", NA), f = c(TRUE, TRUE, TRUE, FALSE))
mydata1

mydata7
str(mydata7)

# subsetting
mydata
mydata[2, 1]
mydata[2, ]
mydata[, 2]
mydata[2:4, ]
mydata[, 2:3]
mydata[, c(1, 3)]
mydata[, "ID"]
mydata[, c("ID", "Passed")]
mydata[c("s1", "s3"), ]

# some useful commands for data frame
mydata
dim(mydata) # dimension
names(mydata)
row.names(mydata)
str(mydata)
summary(mydata)
head(mydata) # first six
head(mydata, n = 3)
tail(mydata) # last six
View(mydata)
nrow(mydata)
ncol(mydata)

# reading data files
getwd()

df_exam <- read.csv("./data/csv_exam.csv")
View(df_exam)
dim(df_exam)
class(df_exam)
head(df_exam)
str(df_exam)
colSums(is.na(df_exam))
is.na(df_exam)
is.na(df_exam$school_type)

sum(is.na(df_exam))
sum(is.na(df_exam$school))

df_exam_na <- read.csv("./data/csv_exam.csv", na.strings = "") # empty string as NA

str(df_exam_na)
colSums(is.na(df_exam_na))
is.na(df_exam_na$school_type)
View(df_exam_na)

df_exam0 <- read.csv("./data/csv_exam.csv", stringsAsFactors = TRUE)
View(df_exam0)
str(df_exam0)
summary(df_exam0)

df_exam1 <- read.csv("./data/csv_exam.csv", stringsAsFactors = TRUE, na.strings = "")
head(df_exam1)
str(df_exam1)
summary(df_exam1)

write.csv(df_exam1, file = "./data/test100.csv")

install.packages("readxl")
library("readxl")

df_exam2 <- read_excel("./data/excel_exam.xlsx")
class(df_exam2)
str(df_exam2)
summary(df_exam2)
View(df_exam2)

# R built-in datasets
library(help = "datasets")
data()
class(iris)
head(iris)

# working with data frame: basics
carmpg <- read.csv("./data/mpg_data.csv", na.strings = "")
head(carmpg)
dim(carmpg)
View(carmpg)
str(carmpg)
summary(carmpg)
sum(is.na(carmpg))
colSums(is.na(carmpg))

mean(carmpg$cty)
max(carmpg$cty)

mean(carmpg[, "cty"])

colSums(is.na(carmpg))

carmpg$total <- (carmpg$cty + carmpg$hwy) / 2
head(carmpg)

carmpg$test <- ifelse(carmpg$total >= 20, "pass", "fail")
head(carmpg)

carmpg1 <- carmpg[, c(1, 3, 5)]
head(carmpg1)

carmpg2 <- carmpg[, -c(5, 7, 8)]
head(carmpg2)

carmpg3 <- carmpg[, c(1:5)]
head(carmpg3)

carmpg4 <- carmpg[, c("year", "manufacturer", "model")]
head(carmpg4)

# not to change order
names(carmpg)
carmpg5 <- carmpg[, names(carmpg) %in% c("year", "manufacturer", "model")]
head(carmpg5)

carmpg6 <- carmpg[, !(names(carmpg) %in% c("year", "manufacturer", "model"))]
head(carmpg6)

# missing data
carmpg <- read.csv("./data/mpg_data1_missing.csv", na.strings = "")
any(is.na(carmpg)) # existence of missing value
sum(is.na(carmpg))

colSums(is.na(carmpg))
sum(is.na(carmpg$cty))
dim(carmpg)

carmpg_nm <- na.omit(carmpg) # remove rows with missing values
colSums(is.na(carmpg_nm))
dim(carmpg_nm)

# alternatively, use complete.cases() as follows
complete.cases(carmpg)
carmpg_nm1 <- carmpg[complete.cases(carmpg), ]
colSums(is.na(carmpg_nm1))
dim(carmpg_nm)

# imputation
colSums(is.na(carmpg))
carmpg_imp1 <- carmpg
is.na(carmpg$cty)
carmpg_imp1$cty[is.na(carmpg$cty)] <- 0
colSums(is.na(carmpg_imp1))

carmpg_imp2 <- carmpg
mean(carmpg$cty)
mean(carmpg$cty, na.rm = T) # NA remove option
carmpg_imp2$cty[is.na(carmpg$cty)] <- mean(carmpg$cty, na.rm = T)
colSums(is.na(carmpg_imp2))

# help
help("colSums")
?mean()
