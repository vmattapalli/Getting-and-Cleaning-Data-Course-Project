
##install.packages("RCurl")
##library(RCurl)
## Download the dataset:

  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
 
## unzip the dataset:
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
 setwd("E:/Data Sciences/Materials/data/data/UCI HAR Dataset")
# Load Activity Labels
ActivityLabels <- read.table("activity_labels.txt")
ActivityLabels[,2] <- as.character(ActivityLabels[,2])

# Load Features
Features <- read.table("features.txt")
Features[,2] <- as.character(Features[,2])

# Extract the  mean data
FeaturesWanted <- grep(".*mean.*|.*std.*", Features[,2])
FeaturesWanted.names <- Features[featuresWanted,2]
FeaturesWanted.names = gsub('-mean', 'Mean', FeaturesWanted.names)

# Extract the standard deviation data
FeaturesWanted.names = gsub('-std', 'Std', FeaturesWanted.names)
FeaturesWanted.names <- gsub('[-()]', '', FeaturesWanted.names)

# Loading the train datasets
Train <- read.table("./train/X_train.txt")[FeaturesWanted]
TrainActivities <- read.table("./train/Y_train.txt")
TrainSubjects <- read.table("./train/subject_train.txt")
Train <- cbind(TrainSubjects, TrainActivities, Train)

# Loading the test datasets
Test <- read.table("./test/X_test.txt")[featuresWanted]
TestActivities <- read.table("./test/Y_test.txt")
TestSubjects <- read.table("./test/subject_test.txt")
Test <- cbind(TestSubjects, TestActivities, Test)

# Binding datasets and add labels
AllData <- rbind(Train, Test)
colnames(AllData) <- c("Subject", "Activity", FeaturesWanted.names)

# Modify activities & subjects into factors
AllData$Activity <- factor(AllData$Activity, levels = ActivityLabels[,1], labels = ActivityLabels[,2])
AllData$Subject <- as.factor(AllData$Subject)
 library("reshape2")

AllData.melted <- melt(AllData, id = c("Subject", "Activity"))
AllData.mean <- dcast(AllData.melted, Subject + Activity ~ variable, mean)

## Tidy data Creation
write.table(AllData.mean, "Tidy Data.txt", row.names = FALSE, quote = FALSE)
