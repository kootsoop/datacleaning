#
# Data Cleaning Project : Tidy and clean the Human Activity Recognition Dataset.
#
# (C) Peter J. Kootsookos 2016
#
# Dataset used from:
#
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
#     Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly 
#     Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
#     Vitoria-Gasteiz, Spain. Dec 2012
#
# From: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project
# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

# Change data_directory to where the unzipped data from
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# is located.
data_directory <- "/Users/kootsookosp/Documents/Professional/Coursera/DataCleaning/UCI HAR Dataset"
setwd(data_directory)

# First, check that we have the test and train subdirectories
test_directory <- "test"
if (!file.exists(test_directory))
{
  stop("'test' data directory does not exist.")
}
train_directory <- "train"
if (!file.exists(train_directory))
{
  stop("'train' data directory does not exist.")
}

# Function to read a table and rename all the columns (if possible)
read_table_and_rename <- function(filename, column_names) {
  data <- read.table(filename)
  if (dim(data)[2] != length(column_names)) {
    stop(paste("Incorrect number of column names given!", dim(data)[2], " vs ", length(column_names)))
  }
  colnames(data) <- column_names
  data
}

# Get features and activities
features <- read_table_and_rename("features.txt", c("Feature_ID", "feature_name"))
activities <- read_table_and_rename("activity_labels.txt", c("activity_id", "activity_name"))

test_files <- c("X_test.txt","subject_test.txt","y_test.txt")
train_files <- c("X_train.txt","subject_train.txt","y_train.txt")

X1 <- read_table_and_rename("test/X_test.txt", as.vector(features$feature_name))
X2 <- read_table_and_rename("train/X_train.txt", as.vector(features$feature_name))
y1 <- read_table_and_rename("test/y_test.txt", "activity_id")
y2 <- read_table_and_rename("train/y_train.txt", "activity_id")
subject1 <- read_table_and_rename("test/subject_test.txt", "subject_id")
subject2 <- read_table_and_rename("train/subject_train.txt", "subject_id")

# 1. Merges the training and the test sets to create one data set.
# A: total_raw_data will contain the merged test and training data sets.
total_raw_data <- cbind(subject1, y1, X1)
total_raw_data <- rbind(total_raw_data, cbind(subject2, y2, X2))

# 3. Uses descriptive activity names to name the activities in the data set
# A: Remap the second column, and then rename it
total_raw_data$activity_id <- activities$activity_name[total_raw_data$activity_id]
names(total_raw_data)[2] <- "activity_name"

# Output the data
write.table(total_raw_data, "raw_tidy_data.txt")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# A: mean_and_std will that subset of total_raw_data  for which the column names contain "mean" or "std" (and the subject ID and activity ID)
features_to_keep <- c(TRUE, TRUE, grepl("mean\\(|std\\(", features$feature_name))
mean_and_std <- total_raw_data[,features_to_keep]

# 5. From the data set in step 4, cresates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
total_cols <- dim(mean_and_std)[2]
tidy_data <- aggregate( mean_and_std[,3:total_cols], list(subject_id = mean_and_std$subject_id, activity_name = mean_and_std$activity_name), FUN = mean)

write.table(tidy_data, "tidy_summary_data.txt")
