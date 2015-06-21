# specify the url and download the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "dataset.zip", method = "curl")
# unzip the dataset
unzip("dataset.zip")

######################################################
##################### STEP 1 #########################
######################################################
# read the all measurements in training data and testing data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

# combine training data and testing data into one dataset
data <- rbind(train_data, test_data)
######################################################
##################### STEP 2 #########################
######################################################
# read the feature description file
feature <- read.table("./UCI HAR Dataset/features.txt")
names(feature) <- c("column", "description")

# Extracts only the measurements on the mean and standard deviation for each measurement
# (which has the term "mean()" and "std()" in the feature description)
data <- data[, feature[grep('mean\\(\\)|std\\(\\)', feature$description), "column"]]

######################################################
##################### STEP 3 #########################
######################################################
library(plyr)
# read the activity in training and testing dataset 
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
# combine training and testing activities into one unified list of activity
activity <- rbind(train_activity, test_activity)
activity <- tbl_df(activity) # convert activity into data frame tbl
names(activity) <- "number" # set the column name into "number"
# read the activity label
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_label <- tbl_df(activity_label) # convert activity_label into data frame tbl
names(activity_label) <- c("number", "description") # set column names into "number" and "description"
# join activity and activity_label so that each activity has the corresponding label
activity <- join(activity, activity_label) 
# only keep the description (label) of the activity
activity <- select(activity, description)

######################################################
##################### STEP 4 #########################
######################################################
# Appropriately labels the data set with descriptive variable names
names(data) <- feature[grep('mean\\(\\)|std\\(\\)', feature$description), "description"]

######################################################
##################### STEP 5 #########################
######################################################
# read the subject list in training and testing dataset
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
# combine these two lists into a unified subject list
subject <- rbind(train_subject, test_subject)

# combine both activity and subject and measurement into a data frame
data <- cbind(activity, subject, data)

names(data)[1] <- "activity" # set the first column name as "activity"
names(data)[2] <- "subject"  # set the second column name as "subject"

# group the dataset by both subject and activity
by_activity_subject <- group_by(data, subject, activity)
# creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject
result <- summarise_each(by_activity_subject, funs(mean))

# write result into result.txt file
write.table(result, file = "result.txt", row.names = FALSE)