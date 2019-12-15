# Getting and Cleaning Data Course Project

## Essense of the excersise:

Create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How-To

1. Download the ```UCI HAR Dataset``` at this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Unpack it anywhere you want, then set ```UCI HAR Dataset``` folder as your working directory with ```setwd()```
3. Run the script and get a tidy dataset with all the averages

## Dependencies

```run_analysis.R``` depends on ```data.table``` packages as well as either ```dplyr``` package or ```reshape2``` package. The script will try to load them, so please have those packages installed beforehand.
