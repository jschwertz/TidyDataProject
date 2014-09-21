## Script cleans sensor data from accelerometers in Galaxy S device for analysis.
## 1. Merges the training and test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Load required libraries.
library(plyr)

## If data directory exists, change to that directory.
## Else, create data directory, download and unzip raw data files.
  if(file.exists("./data")) {
    setwd("./data")
  } else {
    dir.create("./data")
    fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/zipfile.zip",method="auto")
    setwd("./data")
    unzip("zipfile.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)
  }

## Read raw data files into memory for processing.trainSubj<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
  trainSubj<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
  trainY<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
  trainX<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
  testSubj<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
  testY<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
  testX<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
  features<-read.table("./UCI HAR Dataset/features.txt",header=FALSE)
  activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)

## Join train and test files.
  training <- cbind(trainX,trainY,trainSubj)
  testing <- cbind(testX,testY,testSubj)

## Make the feature names better suited for R with some substitutions
  features[,2] = gsub('-mean', 'Mean', features[,2])
  features[,2] = gsub('-std', 'Std', features[,2])
  features[,2] = gsub('[-()]', '', features[,2])

## Merge training and test sets together
  mrgData = rbind(training, testing)

## Remove working files.
  #remove(trainSubj,testSubj,trainY,testY,trainX,testX,training, testing)

## Select only the data on mean and std. dev.
  selCols <- grep(".*Mean.*|.*Std.*", features[,2])
## Reduce the features table to what we want
  features <- features[selCols,]
## Now add the last two columns (subject and activity)
  selCols <- c(selCols, 562, 563)
## And remove the unwanted columns from allData
  mrgData <- mrgData[,selCols]
## Add the column names (features) to allData
  colnames(mrgData) <- c(features$V2, "Activity", "Subject")
  colnames(mrgData) <- tolower(colnames(mrgData))

  currentActivity = 1
  for (currentActivityLabel in activityLabels$V2) {
    mrgData$activity <- gsub(currentActivity, currentActivityLabel, mrgData$activity)
    currentActivity <- currentActivity + 1
  }

  mrgData$activity <- as.factor(mrgData$activity)
  mrgData$subject <- as.factor(mrgData$subject)

  numCols <- length(colnames(mrgData)) -2

  tidy = aggregate(mrgData[,1:numCols], by=list(activity = mrgData$activity, subject=mrgData$subject), FUN = mean)
## Remove the subject and activity column, since a mean of those has no use
##  tidy[,90] = NULL
##  tidy[,89] = NULL
  write.table(tidy, "tidy.txt", sep="\t", row.name=FALSE)

## Remove working files.
  remove(mrgData, tidy, numCols, activityLabels, features)
  setwd("../")
