# extra
cat("\014")
ls()
rm(list = ls())

# variables and assignment
a <- 6
a
a <- 7
a
print(a)

b <- "a"
b

x <- 3
x

x <- x + 5
x

# vectors and vector operations
x1 <- c(10, 8, 5, 33, 2, 15)
x1
print(x1)

class(x1) # print type of vector

x2 <- c(x1, 1, 2, 22)
x2

x3 <- c(1:5)
x3

x4 <- seq(1, 10)
x4

x5 <- seq(1, 10, by = 2)
x5

x6 <- rep(1, 5)
x6

x7 <- rep(1:3, 5)
x7 <- rep(c(1:3), 5)
x7

x8 <- rep(seq(2, 20, by = 2), 2)
x8

x9 <- rep(c(5, 4), c(2, 3))
x9

x10 <- rep(c(5, 4), each = 3)
x10

x11 <- rep(c(5, 4), 3)
x11

# subsetting
x1
x1[2] # idx starts from 1
x1[2:4]
x1[-3] # show except idx 3
x1

# vectors and vector operations (ctnd)
y <- c(1, 2, 3, 4) * 10
y

x <- c(5, -2, 3, -7)
sort(x) # non-destructive
sort(x, decreasing = TRUE)
x

max(x)
which.max(x)
which.min(x)

x
h <- rev(x)
h

str1 <- c("a", "b", "c")
class(str1)
str1

str2 <- c("Hello", "World")
class(str2)
str2

str3 <- paste(str2, collapse = ", ")
str3

str4 <- paste(str2, collapse = " ")
str4

# remove(str1)
str1

# rm(str2)
str2

# manipulating numbers
x <- c(-7.27, -5.72, 5.23, 3.84, 0.17)
x

round(x)
round(x, digit = 1)

floor(x)
ceiling(x)

trunc(x)
signif(x, 2) # 유효숫자 개수 지정

ages <- runif(20, min = 20, max = 70) # random 20
ages

ages <- floor(ages)
ages

set.seed(99)
ages <- floor(runif(20, min = 20, max = 70))
ages

# functions and packages
install.packages("ggplot2")
library(ggplot2)

x10 <- c("a", "a", "b", "c", "c", "c")
x10
qplot(x10) # 빈도 막대 그래프

# basic data types (modes)
y11 <- c(TRUE, TRUE, FALSE)
class(y11)
y11

y12 <- c("2017-12-22", "2018-03-15")
class(y12)
y12

myd <- as.Date(y12)
myd
class(myd)

myd[2]
myd[1]

days <- myd[2] - myd[1]
days

Sys.Date()
Sys.time()

# factor data type
var1 <- c(1, 2, 3, 1, 2, 3, 3)
var1
class(var1)

var1[3] - var1[1]
var1

var9 <- factor(var1)
var9
class(var9)
levels(var9)

var2 <- factor(c(1, 2, 3, 1, 2, 2, 3))
class(var2)
var2[3] - var2[1]

var3 <- factor(c(1, 2, 3, 1, 2, 2, 3), levels = c(1:5))
var3

gender <- c(rep("male", 2), rep("female", 3))
gender
class(gender)

gender <- factor(gender)
class(gender)
gender
