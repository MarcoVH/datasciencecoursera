#Set your working directory to where the "UCI HAR Dataset" folder is, as in:
#setwd("C:/Users/Marco/Documents/Data Science Specialization/Getting and Cleaning Data/Project")

# Package check -----------------------------------------------------------

if (!require("data.table")) {
  install.packages("data.table")
}
require("data.table")
if (!require("reshape2")) {
  install.packages("reshape2")
}
require("reshape2")

# Loading data ------------------------------------------------------------

# Test
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Train
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Labels
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Merge train and test data (Part 1) --------------------------------------

X<-rbind(X_test, X_train)
y<-rbind(y_test, y_train)
subject<-rbind(subject_test, subject_train)

# Removes old data
rm(X_test, X_train, y_test, y_train, subject_test, subject_train)

# Labeling data -----------------------------------------------------------

# Column names for X
names(X)<-features

# Adds descriptive activity names to name the activities in y
y[,2] = activity_labels[y[,1]]

# Column names for y and subject
names(y) = c("Activity_ID", "Activity_Label")
names(subject) = "Subject"


# Extracts only measurements on the mean and standard deviation -----------

Indicator1<-grepl("mean()", features, fixed=T)
Indicator2<-grepl("std()", features, fixed=T)
Indicator<-as.logical(Indicator1+Indicator2)
X<-X[,Indicator]

# Merge train and test data (Part 2) --------------------------------------

Data<-cbind(subject, X, y)

# Removes old data
rm(subject, X, y)


# Tidy data ---------------------------------------------------------------

# Fixed
id_labels<-c("Subject","Activity_Label", "Activity_ID")

# Variable
variable_labels<- setdiff(colnames(Data), id_labels)
  
# Melt and cast (reshape2)
melt_data<-melt(Data, id=id_labels, measure = variable_labels)
Neat<-dcast(melt_data, Subject + Activity_Label ~ variable, mean)

# Write tidy data to a file
write.table(Neat, file = "./Neat.txt", row.names=F)


