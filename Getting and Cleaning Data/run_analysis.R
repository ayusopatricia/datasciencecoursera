# The files must exists
run_analysis <- function() {
  
  # Reading Data from X_train file 
  Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
  
  # Reading Data from X_test file 
  Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
  
  # Binding X data
  Xdata <- rbind(Xtest, Xtrain)
  
  # Reading Data from features file
  features <- read.table("./UCI HAR Dataset/features.txt")
  
  # Converting features into a vector
  tFeatures<-t(features$V2)
  
  # Assigning names to columns
  colnames(Xdata) <- tFeatures
  
  # Reading Data from Y_train file
  Ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
  
  # Reading Data from Y_test file
  Ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
  
  # Binding Y data
  Ydata <- rbind(Ytest, Ytrain)
  
  # Reading Data from Y_train file
  Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  
  # Reading Data from Y_test file
  Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  
  # Binding Y data
  Sdata <- rbind(Stest, Strain)
  
  # Renaming column V1 in Sdata
  colnames(Sdata) <- "Subjects"
  
  # Binding train data
  bindData <- cbind(Sdata, Ydata, Xdata)
  
  # Reading Data from Activity Labels file
  activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
  
  # Renaming columns in Activities
  colnames(activities) <- c("V1","Activities")
  
  # Merging all Data with activities by column V0
  data <- merge(activities, bindData, by="V1")
  
  # Removing V1 column
  data$V1 <- NULL
  
  # Getting Mean and STD measurements
  tidyData = data[, grepl("mean\\(\\)|std\\(\\)|Activities|Subjects", names(data))]
  
  # Converting data.frame to data.table
  library(data.table)
  dataTable <- data.table(tidyData)
  
  # Setting keys
  setkey(dataTable,Activities,Subjects)
  
  # Getting Average by Subject and Activity
  dataAvg <- dataTable[, lapply(.SD,mean), by=key(dataTable)]
  
  # Putting the data into a TXT file
  write.table(data,'~/run_analysis.txt')
    
} 