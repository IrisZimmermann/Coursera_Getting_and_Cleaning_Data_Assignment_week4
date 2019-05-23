#load libraries 
library(dplyr)

#read data from txt-files
#read training data
train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")
train_sub <- read.table("./train/subject_train.txt")

#read test data
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")
test_sub <- read.table("./test/subject_test.txt")

# read activity labels 
act_labels <- read.table("./activity_labels.txt")

# read features
raw_features <- read.table("./features.txt") 

# for selecting only mean or std columns later
interest_features <- raw_features[grep("mean\\(\\)|std\\(\\)", raw_features[,2]),]

# merge training and test sets
merged_x   <- rbind(train_x, test_x) # rbind combines two R objects by rows
merged_x <- merged_x[,interest_features[,1]]
merged_y   <- rbind(train_y, test_y) 
merged_sub <- rbind(train_sub, test_sub) 

# set column names
colnames(merged_x)   <- interest_features[,2]
colnames(merged_y)   <- "activity"
colnames(merged_sub) <- "subject"

# set actvity labels
merged_y$activitylabel <- factor(merged_y$activity, labels = as.character(act_labels[,2]))
alabel <- merged_y[,2]
# merge everything
merged_total <- cbind(merged_sub,merged_y,merged_x)

# Create independent tidy data set with average of each variable for each activity and each subject
colnames(merged_sub) <- "subject"
merged_total_2 <- cbind(merged_x, alabel, merged_sub)
average_merged_total_2 <- merged_total_2 %>% group_by(alabel, subject) %>% summarize_each(funs(mean))


