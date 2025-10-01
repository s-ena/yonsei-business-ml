# 1
set.seed(99)
x <- matrix(runif(20, min = 0, max = 100), ncol = 4)
x

# 2
round(rowSums(x))
round(colSums(x))

# 3
my_product <- data.frame(a = c("Cereal", "Milk", "Rice", "Cookie"), b = c(15, 20, 30, 50), c = c(2000, 1000, 1500, 500), d = c("1a", "1b", "2c", "3a"), stringsAsFactors = TRUE)
my_product

# 4
str(my_product)

# 5
names(my_product) <- c("Product", "Units_sold", "Price", "Location")
names(my_product)

# 6
row.names(my_product) <- c("P1", "P2", "P3", "P4")
row.names(my_product)

# 7
summary(my_product)

# 8
my_product[4, 1]

# 9
my_product[, names(my_product) %in% c("Product", "Units_sold")]

# 10
iris_new <- iris
str(iris_new)
iris_new[c(1:10), ]

# 11
colSums(is.na(iris_new))

# 12
iris_new[3, 1] <- NA

# 13
head(iris_new)
sum(is.na(iris_new[, "Sepal.Length"]))

# 14
iris_new[3, 1] <- mean(iris_new[, "Sepal.Length"], na.rm = T)
iris_new[3, 1]

# 15
# attached
