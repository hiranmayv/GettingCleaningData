library(tidyr)
library(dplyr)
library(stringr)

## Assuming the working directory is set to the UCI HAR Dataset folder

##Activity Labels
act_labels <- read.csv("activity_labels.txt",header = FALSE)

## Separate activity code from the label
act_labels2 <- separate(act_labels, V1, c("activity_code","activity_label"), sep=" ")
fac <- act_labels2[,2]
## Load Variables from features.txt
features <- read.csv("features.txt",sep = " ",header = FALSE)
## Load subject list 
subject_train <- read.csv("train/subject_train.txt",  header=FALSE)
## set column name to Subject
colnames(subject_train) <- "Subject"

## Load training data  - Activity 
traintbl_Y <- read.csv("train/y_train.txt",sep=" ",header=FALSE)
## Load training data - vectors with time and frequency domain variables
traintbl_X <- read.table("train/x_train.txt",header=FALSE)
## Load test data
subject_test <- read.csv("test/subject_test.txt",  header=FALSE)


## Load training data - vectors with time and frequency domain variables
testtbl_X <- read.csv("test/x_test.txt", sep=" ",header=FALSE)
##Load test subject data
testtbl_Y <- read.table("test/y_test.txt", header=FALSE)

## Create train and test data sets with
## Subject, Activity, time/frequency variables
traintbl <- cbind(subject_train,traintbl_Y,traintbl_X)
testtbl <- cbind(subject_test,testtbl_Y, testtbl_X)

##MERGE TRAINING AND TEST DATASETS
tidyset <- rbind(testtbl,traintbl)

sub <- rbind(subject_test,subject_train)
colnames(sub) <- "Subject"
act <- rbind(testtbl_Y,traintbl_Y)
colnames(act) <- "Activity"

#USE DESCRIPTIVE  ACTIVITY NAMES TO NAME THE ACTIVITY
# Convert Activity Code to Activity Labels 
for ( i in 1:6) {
    act[act[,1]==i,1] = fac[i]
}


#APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLES NAMES
## Get column names - Variable names
cols <- features[,2]
cols <- str_replace_all(cols, "[^[:alnum:]]", "")

## convert variable names to meaningful names for each of the x-axis, y-axis, z axis 
## readings
cols <- gsub("tBodyAccJerk","TimeDomainBodyLinearAcceleration",cols)
cols <- gsub("tBodyGyroJerk","TimeDomainBodyAngularVelocity",cols)
cols <- gsub("tBodyAcc","TimeDomainBodyAcceleration",cols)
cols <- gsub("tGravityAcc","TimeDomainGravityAccelertion",cols)
cols <- gsub("tBodyGyro","TimeDomainBodyGyroscopr",cols)
cols <- gsub("Mag","Magnitude",cols)
cols <- gsub("fBodyBody","fBody",cols)
cols <- gsub("fBodyAccJerk","FrequencyDomainBodyLinearAcceleration",cols)
cols <- gsub("fBodyGyroJerk","FrequencyDomainBodyAngularVelocity",cols)
cols <- gsub("fBodyAcc","FrequencyDomainBodyAcceleration",cols)
cols <- gsub("fBodyGyro","FrequencyDomainBodyGyroscope",cols)


## Set column names for the time and frequency domain variables 
colnames(tidyset) <-c("Subject","Activity",cols) 
tX <- tidyset[,1:563]

#EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION 
#FOR EACH MEASUREMENT
## select all columns which give "mean" data into tXmean
tXmean <- select(tX,contains("mean"))
##  select al columns which give "standard deviation" data into tXstd
tXstd <- select(tX,contains("std"))
#Bind the two sets of measurements with subject and activity
tidysetf <- cbind(sub,act,tXmean,tXstd)


##CREATE INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE
#FOR EACH ACTIVITY AND EACH SUBJECT
# First group the data set
grp <- group_by(tidysetf, Subject,Activity)

# summarize all the columns (excluding activty and subject) to get their means
summ_grp <- summarise_each(grp, funs(mean), -c(Activity,Subject))

#write table to output
write.table(summ_grp,"Tidyset.txt", row.names =FALSE,sep = "\t")

