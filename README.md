---
title: "README"
author: "Ashok"
date: "November 20, 2015"
output: html_document
---

# Run_Analysis.R Explained

Include the libraries

```r
require("dplyr")
```

```
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

read the file and list down the files

```r
options(width = 250)
targetfile<-"getdata-projectfiles-UCI HAR Dataset.zip"

#list the files in the zip
unzip(targetfile, list = TRUE)
```

```
##                                                            Name   Length                Date
## 1                           UCI HAR Dataset/activity_labels.txt       80 2012-10-10 15:55:00
## 2                                  UCI HAR Dataset/features.txt    15785 2012-10-11 13:41:00
## 3                             UCI HAR Dataset/features_info.txt     2809 2012-10-15 15:44:00
## 4                                    UCI HAR Dataset/README.txt     4453 2012-12-10 10:38:00
## 5                                         UCI HAR Dataset/test/        0 2012-11-29 17:01:00
## 6                        UCI HAR Dataset/test/Inertial Signals/        0 2012-11-29 17:01:00
## 7     UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt  6041350 2012-11-29 15:08:00
## 8     UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt  6041350 2012-11-29 15:08:00
## 9     UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt  6041350 2012-11-29 15:08:00
## 10   UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt  6041350 2012-11-29 15:09:00
## 11   UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt  6041350 2012-11-29 15:09:00
## 12   UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt  6041350 2012-11-29 15:09:00
## 13   UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt  6041350 2012-11-29 15:08:00
## 14   UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt  6041350 2012-11-29 15:09:00
## 15   UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt  6041350 2012-11-29 15:09:00
## 16                        UCI HAR Dataset/test/subject_test.txt     7934 2012-11-29 15:09:00
## 17                              UCI HAR Dataset/test/X_test.txt 26458166 2012-11-29 15:25:00
## 18                              UCI HAR Dataset/test/y_test.txt     5894 2012-11-29 15:09:00
## 19                                       UCI HAR Dataset/train/        0 2012-11-29 17:01:00
## 20                      UCI HAR Dataset/train/Inertial Signals/        0 2012-11-29 17:01:00
## 21  UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt 15071600 2012-11-29 15:08:00
## 22  UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt 15071600 2012-11-29 15:08:00
## 23  UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt 15071600 2012-11-29 15:08:00
## 24 UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt 15071600 2012-11-29 15:09:00
## 25 UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt 15071600 2012-11-29 15:09:00
## 26 UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt 15071600 2012-11-29 15:09:00
## 27 UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt 15071600 2012-11-29 15:08:00
## 28 UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt 15071600 2012-11-29 15:08:00
## 29 UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt 15071600 2012-11-29 15:08:00
## 30                      UCI HAR Dataset/train/subject_train.txt    20152 2012-11-29 15:09:00
## 31                            UCI HAR Dataset/train/X_train.txt 66006256 2012-11-29 15:25:00
## 32                            UCI HAR Dataset/train/y_train.txt    14704 2012-11-29 15:09:00
```

Read the test set and training set files

```r
y_test <- read.table(unz(targetfile, "UCI HAR Dataset/test/y_test.txt"))
x_test <- read.table(unz(targetfile, "UCI HAR Dataset/test/X_test.txt"))
y_train <- read.table(unz(targetfile, "UCI HAR Dataset/train/y_train.txt"))
x_train <- read.table(unz(targetfile, "UCI HAR Dataset/train/X_train.txt"))

subject_test <- read.table(unz(targetfile, "UCI HAR Dataset/test/subject_test.txt"))
subject_train <- read.table(unz(targetfile, "UCI HAR Dataset/train/subject_train.txt"))

features <- read.table(unz(targetfile, "UCI HAR Dataset/features.txt"))
activity_labels <- read.table(unz(targetfile, "UCI HAR Dataset/activity_labels.txt"))
names(activity_labels)<-c('V1', 'Activity')
```


Combine the datasets

```r
x<-rbind(x_train, x_test)
y<-rbind(y_train, y_test)
```

Combine the subject_ids in same order 

```r
subject<-rbind(subject_train, subject_test)
```

Set the names to valid varible names

```r
#names(x)<-make.names(names=features[[2]], unique=TRUE, allow_ = TRUE)
names(x)<-features[[2]]
names(subject)<-"subject_id"
names(activity_labels)<-c('V1','Activity')
```

Add a column with the subject ids merge them

```r
dt<-cbind(subject,x)
```

Merge with activity data with labels

```r
dt<-cbind(y, dt)
dt<-merge(dt, activity_labels, by = 'V1')
```

```
## Warning in merge.data.frame(dt, activity_labels, by = "V1"): column names 'fBodyAcc-bandsEnergy()-1,8', 'fBodyAcc-bandsEnergy()-9,16', 'fBodyAcc-bandsEnergy()-17,24', 'fBodyAcc-bandsEnergy()-25,32', 'fBodyAcc-bandsEnergy()-33,40', 'fBodyAcc-
## bandsEnergy()-41,48', 'fBodyAcc-bandsEnergy()-49,56', 'fBodyAcc-bandsEnergy()-57,64', 'fBodyAcc-bandsEnergy()-1,16', 'fBodyAcc-bandsEnergy()-17,32', 'fBodyAcc-bandsEnergy()-33,48', 'fBodyAcc-bandsEnergy()-49,64', 'fBodyAcc-bandsEnergy()-1,24',
## 'fBodyAcc-bandsEnergy()-25,48', 'fBodyAcc-bandsEnergy()-1,8', 'fBodyAcc-bandsEnergy()-9,16', 'fBodyAcc-bandsEnergy()-17,24', 'fBodyAcc-bandsEnergy()-25,32', 'fBodyAcc-bandsEnergy()-33,40', 'fBodyAcc-bandsEnergy()-41,48', 'fBodyAcc-
## bandsEnergy()-49,56', 'fBodyAcc-bandsEnergy()-57,64', 'fBodyAcc-bandsEnergy()-1,16', 'fBodyAcc-bandsEnergy()-17,32', 'fBodyAcc-bandsEnergy()-33,48', 'fBodyAcc-bandsEnergy()-49,64', 'fBodyAcc-bandsEnergy()-1,24', 'fBodyAcc-bandsEnergy()-25,48',
## 'fBodyAccJerk-bandsEnergy()-1,8', 'fBodyAccJerk-bandsEnergy()-9,16', 'fBodyAccJerk-bandsEnergy()-17,24', 'fBodyAccJerk-bandsEnergy()-25,32', 'fBodyAccJerk-bandsEnergy()-33,40', 'fBodyAccJerk-bandsEnergy()-41,48', 'fBodyAccJerk-bandsEnergy()-49,56',
## 'fBodyAccJerk-bandsEnergy()-57,64', 'fBodyAccJerk-bandsEnergy()-1,16', 'fBodyAccJerk-bandsEnergy()-17,32', 'fBodyAccJerk-bandsEnergy()-33,48', 'fBodyAccJerk-bandsEnergy()-49,64', 'fBodyAccJerk-bandsEnergy()-1,24', 'fBodyAccJerk-bandsEnergy()-25,48',
## 'fBodyAccJerk-bandsEnergy()-1,8', 'fBodyAccJerk-bandsEnergy()-9,16', 'fBodyAccJerk-bandsEnergy()-17,24', 'fBodyAccJerk-bandsEnergy()-25,32', 'fBodyAccJerk-bandsEnergy()-33,40', 'fBodyAccJerk-bandsEnergy()-41,48', 'fBodyAccJerk-bandsEnergy()-49,56',
## 'fBodyAccJerk-bandsEnergy()-57,64', 'fBodyAccJerk-bandsEnergy()-1,16', 'fBodyAccJerk-bandsEnergy()-17,32', 'fBodyAccJerk-bandsEnergy()-33,48', 'fBodyAccJerk-bandsEnergy()-49,64', 'fBodyAccJerk-bandsEnergy()-1,24', 'fBodyAccJerk-bandsEnergy()-25,48',
## 'fBodyGyro-bandsEnergy()-1,8', 'fBodyGyro-bandsEnergy()-9,16', 'fBodyGyro-bandsEnergy()-17,24', 'fBodyGyro-bandsEnergy()-25,32', 'fBodyGyro-bandsEnergy()-33,40', 'fBodyGyro-bandsEnergy()-41,48', 'fBodyGyro-bandsEnergy()-49,56', 'fBodyGyro-
## bandsEnergy()-57,64', 'fBodyGyro-bandsEnergy()-1,16', 'fBodyGyro-bandsEnergy()-17,32', 'fBodyGyro-bandsEnergy()-33,48', 'fBodyGyro-bandsEnergy()-49,64', 'fBodyGyro-bandsEnergy()-1,24', 'fBodyGyro-bandsEnergy()-25,48', 'fBodyGyro-bandsEnergy()-1,8',
## 'fBodyGyro-bandsEnergy()-9,16', 'fBodyGyro-bandsEnergy()-17,24', 'fBodyGyro-bandsEnergy()-25,32', 'fBodyGyro-bandsEnergy()-33,40', 'fBodyGyro-bandsEnergy()-41,48', 'fBodyGyro-bandsEnergy()-49,56', 'fBodyGyro-bandsEnergy()-57,64', 'fBodyGyro-
## bandsEnergy()-1,16', 'fBodyGyro-bandsEnergy()-17,32', 'fBodyGyro-bandsEnergy()-33,48', 'fBodyGyro-bandsEnergy()-49,64', 'fBodyGyro-bandsEnergy()-1,24', 'fBodyGyro-bandsEnergy()-25,48' are duplicated in the result
```


Now we have all the data, need to filter as per the assignment

```r
reqcols<-names(dt)[grepl(pattern = "std\\(\\)|mean\\(\\)", x = names(dt))]
reqcols <- c(reqcols, "Activity", "subject_id")
dt<- dt[,reqcols]
```

Create tidy data set

```r
#create groups
dt_groups <- group_by(dt, subject_id, Activity)

final <- summarise_each(dt_groups, funs( mean))
```

Write the final dataset to file

```r
write.table(final, file="tidydataset.txt", row.names = FALSE)
```
