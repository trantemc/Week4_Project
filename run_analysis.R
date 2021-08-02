# Load necessary libraries
library(dplyr)
library(data.table)

# Data was downloaded and unzipped into a folder called "UCI.HAR.Dataset"
# Import Activity Data
Activity.Test <- read.table("./UCI.HAR.Dataset/test/y_test.txt", header = FALSE)
Activity.Train <- read.table("./UCI.HAR.Dataset/train/y_train.txt", header = FALSE)

# Import Features Information
Features.Test <- read.table("./UCI.HAR.Dataset/test/x_test.txt", header = FALSE)
Features.Train <- read.table("./UCI.HAR.Dataset/train/x_train.txt", header = FALSE)

# Import Subject Information
Subject.Test <- read.table("./UCI.HAR.Dataset/test/subject_test.txt", header = FALSE)
Subject.Train <- read.table("./UCI.HAR.Dataset/train/subject_train.txt", header = FALSE)

# Import Activity Labels
Activity.Labels <- read.table("./UCI.HAR.Dataset/activity_labels.txt", header = FALSE)

# Import Feature Names
Feature.Names <- read.table("./UCI.HAR.Dataset/features.txt", header = FALSE)

# Assign proper column names
colnames(Activity.Test) <- "ActivityID"
colnames(Activity.Train) <- "ActivityID"
colnames(Features.Test) <- Feature.Names[,2]
colnames(Features.Train) <- Feature.Names[,2]
colnames(Subject.Test) <- "SubjectID"
colnames(Subject.Train) <- "SubjectID"
colnames(Activity.Labels) <- c("ActivityID","Activity")

# Merge Train and Test data into two separate data sets using cbind
Train.Data <- cbind(Subject.Train, Activity.Train, Features.Train)
Test.Data <- cbind(Subject.Test, Activity.Test, Features.Test)
# Finally, merge Train and Test data to one large data set using rbind
All.Data <- rbind(Train.Data, Test.Data)
# Select out only columns containing mean or std measurements
All.Data <- All.Data %>% select(SubjectID, ActivityID, contains("mean"), contains("std"))

# Use activity labels instead of actividy IDs
All.Data$ActivityID <- Activity.Labels[All.Data$ActivityID, 2]

# Use descriptive activity names to name the activities in the data sets
names(All.Data)<-gsub("^t", "time", names(All.Data))
names(All.Data)<-gsub("^f", "frequency", names(All.Data))
names(All.Data)<-gsub("Acc", "Accelerometer", names(All.Data))
names(All.Data)<-gsub("Gyro", "Gyroscope", names(All.Data))
names(All.Data)<-gsub("Mag", "Magnitude", names(All.Data))
names(All.Data)<-gsub("BodyBody", "Body", names(All.Data))

# Finally, create a final tidy data set with the average for each individual by activity
FinalTidyData <- aggregate(. ~SubjectID + ActivityID, All.Data, mean)
# Export the final tidy data set
write.table(FinalTidyData, "FinalTidyData.txt", row.names = FALSE)
