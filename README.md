GettingCleaningData
===================

Project repo for Coursera course, Getting and Cleaning Data


##Workflow for this analysis

The zip file is first downloaded and unzipped from internet.

###Merges the training and the test sets to create one data set.
The training and test datasets (x, y, and subject) are loaded from the respective files and are merged to become a complete dataset. The columns are activity (y), subject and measurements (x).

###Extracts only the measurements on the mean and standard deviation for each measurement. 
The features capturing mean and standard deviation measurements are filtered and kept for analysis. I used grepl to check if mean() or std() substring is within the feature name in order to determine whether to keep this variable, where column name is matched by feature ID.

###Uses descriptive activity names to name the activities in the data set
Iterating through the activity values and match the activity ID to activity name. sapply is used.

###Appropriately labels the data set with descriptive variable names. 
The dataset variables are named by Activity, Subject, and feature IDs.

###Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
1. The dataset is split into groups identified by activity and subject jointly.
2. Iterating through each individual group, compute and averages for the variables. The activity and subject are also returned in the results.
3. The results are transformed into a data frame, with column names by group ID (activity and subject), row names by features, activity and subject. 
4. The data frame is transposed.
5. The second data frame is created by meshing the previous transposed data frame. The mesh routine uses activity and subject as identifiers and the features are measurement variables.
