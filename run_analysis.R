library(dplyr)

#downloading the zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "dataset.zip")

#unzipping the file
unzip("dataset.zip")

#reading the features
features<-read.table("UCI HAR Dataset/features.txt")


#reading the test data
test_data<-read.table("UCI HAR Dataset/test/X_test.txt")

colnames(test_data)<-features$V2

test_data_subject<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = c("Subject"))

test_data_activity<-read.table("UCI HAR Dataset/test/y_test.txt",col.names = c("Activity"))

test_data<-cbind(test_data,test_data_subject,test_data_activity)


#reading the training data
train_data<-read.table("UCI HAR Dataset/train/X_train.txt")

colnames(train_data)<-features$V2

train_data_subject<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = c("Subject"))

train_data_activity<-read.table("UCI HAR Dataset/train/y_train.txt",col.names = c("Activity"))

train_data<-cbind(train_data,train_data_subject,train_data_activity)


#joining the two datasets
full_data<-rbind(test_data,train_data)

#filtering the relevant colums
relevant_data<-full_data[,grep(colnames(full_data),pattern="(mean|std)\\(\\)|Activity|Subject")]

#fixing column names
colnames(relevant_data)<-gsub(colnames(relevant_data),pattern="[()]",replacement = "")

#reading activity labels
activityLabels <- read.table( "UCI HAR Dataset/activity_labels.txt", col.names = c("classLabels", "activityName"))

#assign activity names in our dataset
relevant_data[["Activity"]] <- factor(relevant_data[, "Activity"]
                                 , levels = activityLabels[["classLabels"]]
                                 , labels = activityLabels[["activityName"]])

#calculate the mean for each numeric variable grouping by Subject and Activity
tidy_dataset<-relevant_data %>% group_by(Subject,Activity) %>% summarise(across(where(is.numeric), mean)) %>% as.data.frame()

#write the tidy dataset to a file
write.table(tidy_dataset,file="tidy_dataset.txt", row.names = FALSE)
