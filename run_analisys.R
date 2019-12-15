# Create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Step 0.1 Preparation. Load packages to be used later in the script. Set working directory to the one with all the data.

  library(dplyr)
  library(reshape2)
  library(data.table)
  
  setwd("C:/Users/Admin/Desktop/R/UCI HAR Dataset") ## change to your actual path here before trying out

## Step 0.2 Load the data.

  con <- file("train/subject_train.txt")
  trsubject <- read.table(con)
  close(con)
  
  con <- file("train/X_train.txt")
  xtrain <- read.table(con)
  close(con)
  
  con <- file("train/y_train.txt")
  ytrain <- read.table(con)
  close(con)
  
  con <- file("test/subject_test.txt")
  testsubject <- read.table(con)
  close(con)
  
  con <- file("test/X_test.txt")
  xtest <- read.table(con)
  close(con)
  
  con <- file("test/y_test.txt")
  ytest <- read.table(con)
  close(con)
  
  con <- file("activity_labels.txt")
  activity <- read.table(con)[,2]
  close(con)
  
  con <- file("features.txt")
  features <- read.table(con)[,2]
  close(con)

## Step 0.3 Subset mean and std functions from the 'features' (creates a logical vector)

  meanstd <- grepl("mean()|std()",features)

## Step 1 Assign names from the 'features' list to be variable names in the main datafile

  names(xtest) = features
  names(xtrain) = features

## Step 2 Apply mean/std logical vector created earlier to both main data subsets

  xtest <- xtest[,meanstd]
  xtrain <- xtrain[,meanstd]

## Step 3 Add new column to the Y datasets decyphering the activity codes

  ytest[,2] <- activity[ytest[,1]]
  ytrain[,2] <- activity[ytrain[,1]]

## Step 3.1 Set descriptive names to the columns in the 'activities' DFs and 'subject' DFs

  names(ytrain) = c("act_id", "activity")
  names(ytest) = c("act_id", "activity")
  names(trsubject) = "subject"
  names(testsubject) = "subject"

## Step 4 Merge columns in the primary datafile (X) with 'Y' dataset and 'subject' dataset, separately for test and train data.

  test <- cbind(testsubject,ytest,xtest)
  train <- cbind(trsubject,ytrain,xtrain)

## Step 4.1 Add a 'group' column to both resulting datafiles indicating whether it belongs to a train or to a test subset

  test$group = "test"
  train$group = "train"

## Step 5 Merge datafiles into one giagantic datafile

  complete <- rbind(test,train)

## Step 6 Introduce some more clarity into the variable/columns names

  names(complete) <- gsub("\\(\\)","", names(complete)) ## remove '()'
  names(complete) <- gsub("std", "SD", names(complete))
  names(complete) <- gsub("mean", "MEAN", names(complete))
  names(complete) <- gsub("^t", "time", names(complete))
  names(complete) <- gsub("^f", "frequency", names(complete))
  names(complete) <- gsub("Acc", "Accelerometer", names(complete))
  names(complete) <- gsub("Gyro", "Gyroscope", names(complete))
  names(complete) <- gsub("Mag", "Magnitude", names(complete))
  names(complete) <- gsub("BodyBody", "Body", names(complete))

## Step 7 Using reshape2 package, create a temp melted table, explicitly excluding all non-functions columns of the dataset, which in my case is 4
  
  melted <- melt(complete,(id.vars = c("subject","activity", "act_id","group")))
  
    ## Cast mean function on the dataset before putting everything back together
  mmean <- dcast(melted, subject + activity + act_id + group ~ variable, mean) 
  
    ## Edit names of the columns for the resulting file...
  names(mmean)[-c(1:4)] <- paste("[mean of]" , names(mmean)[-c(1:4)])

## Step 7ALT Alternatively, we can use dplyr package to get more or less the same resutl (unlike with reshape2 values are rounded by default)
  
    ## turn resulting table into a tbl object
  complete1 <- tbl_df(complete)
  
    ## group by subject and then activity (ID or Label could be used)
  complete1 <- group_by(complete1, subject, act_id)
  
    ## subset required columns and cast mean function to them, which would be applied according to the grouping
  complete1 <- mutate_at(complete1,c(4:82), mean)
  
## Step 7.1 Write the resulting tidy table into file
  
  write.table(mmean, file = "./tidy.txt")