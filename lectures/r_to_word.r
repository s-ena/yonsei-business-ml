carmpg <- read.csv("../data/mpg_data.csv", na.strings = "")
head(carmpg)
dim(carmpg)
View(carmpg)
str(carmpg)
summary(carmpg)
sum(is.na(carmpg))
colSums(is.na(carmpg))

# file > Compile Report > MS Word
