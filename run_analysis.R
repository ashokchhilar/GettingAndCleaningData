require("dplyr")

setwd("C:/Users/aschhila/Desktop/R/GettingAndCleaningData")
#url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

targetfile<-"getdata-projectfiles-UCI HAR Dataset.zip"
#download.file(url, targetfile, method="curl", mode="w")

#list the files in the zip
unzip(targetfile, list = TRUE)

#Read Everything
y_test <- read.table(unz(targetfile, "UCI HAR Dataset/test/y_test.txt"))
x_test <- read.table(unz(targetfile, "UCI HAR Dataset/test/X_test.txt"))
y_train <- read.table(unz(targetfile, "UCI HAR Dataset/train/y_train.txt"))
x_train <- read.table(unz(targetfile, "UCI HAR Dataset/train/X_train.txt"))

subject_test <- read.table(unz(targetfile, "UCI HAR Dataset/test/subject_test.txt"))
subject_train <- read.table(unz(targetfile, "UCI HAR Dataset/train/subject_train.txt"))

features <- read.table(unz(targetfile, "UCI HAR Dataset/features.txt"))
activity_labels <- read.table(unz(targetfile, "UCI HAR Dataset/activity_labels.txt"))
names(activity_labels)<-c('V1', 'Activity')

#Combine the datasets
x<-rbind(x_train, x_test)
y<-rbind(y_train, y_test)

subject<-rbind(subject_train, subject_test)

#Set the names right
names(x)<-features[[2]]
names(subject)<-"subject_id"
names(activity_labels)<-c('V1','Activity')

#Combine with the subject ids
dt<-cbind(subject,x)

#merge with activity data
dt<-cbind(y, dt)
dt<-merge(dt, activity_labels, by = 'V1')


#filter out the unwanted columns
reqcols<-names(dt)[grepl(pattern = "std\\(\\)|mean\\(\\)", x = names(dt))]
reqcols <- c(reqcols, "Activity", "subject_id")
dt<- dt[,reqcols]

#create tidy data set
#create groups
dt_groups <- group_by(dt, subject_id, Activity)

final <- summarise_each(dt_groups, funs( mean))

#write the final dataset
write.table(final, file="tidydataset.txt", row.names = FALSE)
