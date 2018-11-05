# Getting-CleaningData_CourseProject
Human Activity Recognition Using Smartphones Dataset

The run_nalysis.R script includes following steps:
  1. download the data from the following link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  2. unzip
  3. read all the files from the previous path with unzipped data into large list
  4. pull the tables from this list into global environment, with names as names of files
  5. append train to test tables
  6. bind labels & set, rename with features list
  7. extracts only the measurements on the mean and standard deviation for each measurement
  8. summarise the subset by activity and subject
  
 
  
