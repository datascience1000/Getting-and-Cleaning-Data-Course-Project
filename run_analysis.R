## Course Project

## Load Data
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subtrain <- read.table("./train/subject_train.txt")
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subtest <- read.table("./test/subject_test.txt")

features <- read.table("features.txt")
actlab <- read.table("activity_labels.txt")

## Merge Train and Test data
x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subj <- rbind(subtrain, subtest)


## select only mean() and std() measurements
msrmts <- features$V1[ grep("(-mean())|(-std())", features$V2) ]
measurements <- features$V2[ grep("(-mean())|(-std())", features$V2) ]
length(measurements)

x2 <- x[,msrmts]

## create vector of activity names
activity <- actlab$V2[y[,1]]

## merge all data
data <- cbind(subj, activity , x2)

## rename columns
names <- c("Subject", "Activity")
measurements <- as.character(measurements)
names <- append(names, measurements)
colnames(data) <- names

## summarize data
library("reshape2")
library("plyr")
tidydata <- melt(data, id = c("Subject", "Activity"), measure.vars = measurements)
tidydata2 <- ddply( tidydata, .(Subject, Activity, variable), summarize, Avg = (mean( value )) )

## write data to file
write.table(tidydata2, file = "tidydata.txt", row.names = FALSE)

