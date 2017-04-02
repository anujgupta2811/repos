#Pass the directory where the Samsung datasets are present
#For example - ./Documents/FUCI HAR Dataset/UCI HAR Dataset/
merge_data <- function(directory)
{ 
  library("tidyr")
  library("dplyr")
  test_or_train <- c("test", "train")
  merge_dataset <- data.frame()
  features <- read.table(paste(directory,"features.txt",sep = ""))
  activity_labels <- read.table(paste(directory,"activity_labels.txt",sep = ""))
  names(activity_labels)[1] <- "Activity_Id"
  names(activity_labels)[2] <- "Activities"
  
  for (i in test_or_train)
  { 
    #Read Test and Train data set
    subject <- read.table(paste(directory,i, "/subject_", i, ".txt",sep = ""))
    x <- read.table(paste(directory,i, "/X_", i, ".txt" ,sep = ""))
    y <- read.table(paste(directory,i, "/y_",i, ".txt",sep = ""),col.names = "Activity_Id")
    
    #Fetches descriptive activity name
    y1 <- inner_join(y,activity_labels, by= "Activity_Id")
    
    #Labels the dataset with descriptive variable name
    for (i in 1:561)
    {
      names(x)[i] <- as.character(features[i,2])
    }
    
    #Extracts only the measurements with mean and standard deviation
    x <- x [, grepl("mean()", names(x),fixed = TRUE) | grepl("std()", names(x),fixed = TRUE)]
    
    #Merges Test and Train data set
    merge_dataset <- rbind(merge_dataset, cbind(subject,y1[,2],x))
  }
  
  #Assigning names to first and second columns of dataset
  names(merge_dataset)[1] <- "Volunteer_ID"
  names(merge_dataset)[2] <- "Activities"
  
  #Extracting features having 3 axial direction
  Signal <- merge_dataset[,!grepl("Mag", names(merge_dataset),fixed = TRUE)]
  
  #Extracting features having Magnitude
  Magnitude <- merge_dataset[, c(1,2 ,grep("Mag", names(merge_dataset),fixed = TRUE))]
  
  #Calcuating Average of each variable having 3 axial direction for each activity and subject
  Signal_Dataset <- Signal %>% 
       gather(variable, values, -(Volunteer_ID:Activities)) %>% 
       group_by(Volunteer_ID, Activities,variable) %>% 
       summarise(Mean = mean(values)) %>%
       separate(variable, c("Feature","Variable", "Axis"), sep= "-") %>%
       spread(Feature, Mean)
  Signal_Dataset$Variable <- toupper(sub("()","",Signal_Dataset$Variable, fixed = TRUE))
  
  #Writing Tidy Data with 3 axial direction features to file
  write.table(Signal_Dataset, file = "Tidy_Data_Signals.txt", append = FALSE,quote = FALSE, sep = " ", row.names = FALSE, col.names = TRUE)
  
  #Calcuating Average of each variable having Magnitude features for each activity and subject
  Magnitude_Dataset <- Magnitude %>%
    gather(variable, values, -(Volunteer_ID:Activities)) %>% 
    group_by(Volunteer_ID, Activities,variable) %>% 
    summarise(Mean = mean(values)) %>%
    separate(variable, c("Feature","Variable"), sep= "-") %>%
    spread(Feature, Mean)
  Magnitude_Dataset$Variable <- toupper(sub("()","",Magnitude_Dataset$Variable, fixed = TRUE))
  
  #Writing Tidy Data with Magnitude features to file
  write.table(Magnitude_Dataset, file = "Tidy_Data_Magnitude.txt", append = FALSE, quote = FALSE , sep = " ", row.names = FALSE, col.names = TRUE)
  }