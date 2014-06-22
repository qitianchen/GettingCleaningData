##############################################################################
# Getting and Cleaning Data
# John Hopkins University
# Coursera Course Project
# Author: Qitian Chen
# Date: 22 Jun 2014
##############################################################################

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url, 'data.zip', method='curl')
unzip('data.zip')

##############################################################################
#1 Merges the training and the test sets to create one data set.
##############################################################################
df.train.x <- read.table('UCI HAR Dataset/train/X_train.txt')
df.train.y <- read.table('UCI HAR Dataset/train/Y_train.txt')
df.train.sub <- read.table('UCI HAR Dataset/train/subject_train.txt')
df.test.x <- read.table('UCI HAR Dataset/test/X_test.txt')
df.test.y <- read.table('UCI HAR Dataset/test/Y_test.txt')
df.test.sub <- read.table('UCI HAR Dataset/test/subject_test.txt')

df.features <- read.table('UCI HAR Dataset/features.txt')

df.x <- rbind(df.train.x, df.test.x)
colnames(df.x) <- df.features[,1]
df.y <- rbind(df.train.y, df.test.y)
colnames(df.y) <- c("Activity")
df.sub <- rbind(df.train.sub, df.test.sub)
colnames(df.sub) <- c("Subject")
df <- cbind(df.y, df.sub, df.x)

##############################################################################
#2 Extracts only the measurements on the mean and standard deviation for each
#  measurement.
##############################################################################
find.measurement <- function(y) {
  x <- df.features[y,2]
  grepl('mean()', x, fixed=T) | grepl('std()', x, fixed=T)
}
# sapply(colnames(df)[2:10], find.measurement)
selected_measures <- sapply(colnames(df)[3:length(df)], find.measurement)
measurements <- names(selected_measures[selected_measures])
df1 <- cbind(df$Activity, df$Subject, 
             df[, measurements])
colnames(df1)[1:2] <- c("Activity", "Subject")

############################################################################## 
#3 Uses descriptive activity names to name the activities in the data set
##############################################################################
df.activities <- read.table('UCI HAR Dataset/activity_labels.txt')
rownames(df.activities) <- df.activities[,1]
find.activities <- function(x){
  df.activities[x,2]
}
df1$Activity <- sapply(df1$Activity, find.activities)

##############################################################################
#4 Appropriately labels the data set with descriptive variable names. 
##############################################################################
# This has been done in step 1!

##############################################################################
#5 Creates a second, independent tidy data set with the average of each 
#  variable for each activity and each subject. 
##############################################################################
avg.activity.subject <- function(x) {
  res <- sapply(measurements, function(y) mean(x[,y]))
  res['Activity'] <- as.character(x[1,'Activity'])
  res['Subject'] <- as.integer(x[1, 'Subject'])
  res
}
g <- split(df1, interaction(df1$Activity, df1$Subject))
df2 <- as.data.frame(lapply(g, avg.activity.subject))
df2x <- as.data.frame(t(df2))

require(reshape2)
df3 <- melt(df2x, id=c("Activity", "Subject"), 
            measure.vars=measurements, 
            variable.name='Feature', value.name='Value')
rownames(df.activities) <- df.activities[,2]
find.activities.id <- function(x){
  df.activities[x,1]
}
df3$Activity <- sapply(df3$Activity, find.activities.id)

write.table(df3, 'clean_data.txt')
