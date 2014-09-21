TidyDataProject: Getting and Cleaning Data: Course Project
==========================================================

Introduction
------------

This is the Getting and Cleaning Data project as a part of Coursera.org's Data Science Specialization from Johns Hopkins University.  This repository contains a script called run_analysis.R which will merge sensor data from accelerometers in Galaxy S device for analysis.

About the raw data
------------------

The features (561 of them) are unlabeled and can be found in the x_test.txt. 
The activity labels are in the y_test.txt file.
The test subjects are in the subject_test.txt file.

The same holds for the training set.

There are two additional with descriptive names for the columns.

About the script and the tidy dataset
-------------------------------------
run_analysis.R first downloads and extracts the [raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). It then merges the test and training sets together.

After merging testing and training, labels are added and only columns that have to do with mean and standard deviation are kept.

Lastly, the script will create a tidy data set containing the means of all the columns per test subject and per activity.
This tidy dataset will be written to a tab-delimited file called tidy.txt, which can also be found in this repository.

The script then removes the stored variables. 

About the Code Book
-------------------
The CodeBook.md file explains the transformations performed and the resulting data and variables.
