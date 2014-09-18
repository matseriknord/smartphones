library(data.table)
## Download data set and unzip the files
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./dataset.zip", method = "curl")
unzip("./dataset.zip")

## Read in the activity names from file.
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, colClasses = "character")

## Read in the feature names from file.
feature <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, colClasses = "character")

## Read in data and separate by whitespace.
testData <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
testData_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
testData_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
trainingData <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
trainingData_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
trainingData_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

### Name the labels for the activities in the data set (from activity).
testData_activity$V1 <- factor(testData_activity$V1, levels=activity$V1, labels = activity$V2)
trainingData_activity$V1 <- factor(trainingData_activity$V1, levels=activity$V1, labels = activity$V2)

## Label the data set with descriptive names (from feature).
colnames(testData) <- feature$V2
colnames(trainingData) <- feature$V2
colnames(testData_activity) <- c("Activity")
colnames(trainingData_activity) <- c("Activity")
colnames(testData_subject) <- c("Subject")
colnames(trainingData_subject) <- c("Subject")

## Tie together training data sets.
trainingData <- cbind(trainingData, trainingData_activity)
trainingData <- cbind(trainingData, trainingData_subject)

## Tie together test data sets.
testData <- cbind(testData, testData_activity)
testData <- cbind(testData, testData_subject)

## Merge together training and test sets.
mergedData <- rbind(testData, trainingData)

## Calculate mean and standard deviation on the merged set and store in new data sets. Remove any NA's.
mergedDataMean <- sapply(mergedData, mean, na.rm = TRUE)
mergedDataSd <- sapply(mergedData, sd, na.rm = TRUE)

## Create a new tidy data set containing the average of each variable with respect to subject and activity. 
DataTable <- data.table(mergedData)

## Calculate the mean with regard to Acitvity and Subject on each sub set (.SD)
tidyDataSet <- DataTable[, lapply(.SD, mean), by = "Activity,Subject"]

## Write the tidy data set to a text file.
write.table(tidyDataSet, file = "tidyDataSet.txt", row.names = FALSE, sep=",")
