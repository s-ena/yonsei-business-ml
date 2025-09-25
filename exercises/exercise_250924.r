# 1
set.seed(100)
x <- runif(10, min = -10, max = 10)
x

# 2
round(sort(x, decreasing = TRUE))

# 3
floor(x)

# 4
ceiling(x)

# 5
trunc(x)

# 6
x1 <- c(max(x), min(x), mean(x))
x1

# 7
max(x)
min(x)

# 8
x[1:5]
x[2]
x[8]
x[2] + x[8]

# 9
y <- c("apply", "orange", "strawberry")
y

# 10
z <- c(y, "peach")
z

# 11
z1 <- paste(z, collapse = "; ")
z1

# 12
rep(c(2, 5), 10)
rep(seq(1, 10, by = 3), 2)
rep(c(3, 7), c(7, 4))
