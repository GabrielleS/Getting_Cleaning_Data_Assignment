# Set working directory
# you must set this to the same wd as you have saved the zip file.

# Download & unzip zip file from Getting Clean Data Assignment
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile="Dataset.zip", mode="w", method="curl")
data <- unzip(zipfile="Dataset.zip")

# data[5] to data[13] (they ave 2947 rows each) and data[17] to data[25] (they have 7352 rows each)
# are the test and train datasets. Both have 128 columns which are the reading windows.

# Create a dataframe for both the test and training sets 
testSet  = cbind(read.table(data[16]), read.table(data[15]))
trainSet = cbind(read.table(data[28]), read.table(data[27]))

# Merges the training and the test sets to create one data set. Sets column names as well
masterDf           = rbind(testSet, trainSet)
columnNames        = read.table(data[2])
colnames(masterDf) = c("ActivityName", as.character(columnNames$V2))

# Extracts only the measurements on the mean and standard deviation for each measurement
mean_sd_df = cbind(ActivityName = masterDf$ActivityName, masterDf[, grep( c("mean|std"), colnames(masterDf))])

# Uses descriptive activity names to name the activities in the data set
ActivityNamesLookup     = read.table(data[1])
mean_sd_df$ActivityName = ActivityNamesLookup$V2[match(mean_sd_df$ActivityName, ActivityNamesLookup$V1)]

# Appropriately labels the data set with descriptive variable names.
# this was done in a previous step in which the merge is done.

# From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
mean_df = cbind(ActivityName = mean_sd_df$ActivityName, mean_sd_df[, grep( c("mean"), colnames(mean_sd_df))])
mean_df = aggregate(mean_df, by = list(mean_df$ActivityName), FUN= mean)
mean_df

