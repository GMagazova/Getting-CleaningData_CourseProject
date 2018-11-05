##########################################################
# final project
##########################################################

library(dplyr)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")
unzip ("Dataset.zip")

# to list what's inside
unzip ("Dataset.zip",list=TRUE)$Name


#test_id<-read.table("UCI HAR Dataset/train/subject_train.txt")
#total_acc_x_train<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")


basename(list.files("UCI HAR Dataset",recursive = TRUE))

sub(".txt","",basename(list.files("UCI HAR Dataset",recursive = TRUE)))

#https://stackoverflow.com/questions/27911604/loop-through-all-files-in-a-directory-read-and-save-them-in-an-object-r?rq=1
library(tools)
####
files <- list.files(path="UCI HAR Dataset", pattern="*.txt", all.files=T, full.names=T,recursive = TRUE)
files <-files[-(3:4)] ## remove README.txt & features_info.txt
####

filelist <- lapply(files, read.table, header=F)
names(filelist) <- paste0(basename(file_path_sans_ext(files)))
list2env(filelist, envir=.GlobalEnv) 

####
lapply(names(filelist), function(u) {
  assign(u, filelist[[u]]) 
  save(list=u, file=paste0(u, ".Rdata"))
})
####

######################################################################################
# Step 1.Merges the training and the test sets to create one data set.
######################################################################################

#append train to test

for(i in 1:length(ls(pattern = "test")))
{assign(sub("_test","",ls(pattern = "test")[i]), rbind(get(ls(pattern = "test")[i]),get(ls(pattern = "train")[i])))
  }

rm(list=c(ls(pattern="test"),ls(pattern="train")))


# bind labels & set, rename with features list
activity_set<-cbind.data.frame(y, subject,X)

######################################################################################
# Step 4.Appropriately labels the data set with descriptive variable names.
######################################################################################

names(activity_set)<-c('activity', 'subject',paste(features$V1,features$V2, sep="_"))


# function that adjust the variable name into column name
rename_col<-function(){
  names(a)<-paste(deparse(substitute(a)), names(a), sep=".")
  }

#

lapply(ls(pattern = "body|total"), rename_col)

for(i in 1:length(ls(pattern = "body|total"))){
  
  rename_col(ls(pattern = "body|total")[[i]])
}


##### to change 

names(body_acc_x)<-paste(deparse(substitute(body_acc_x)), names(body_acc_x), sep=".")
names(body_acc_y)<-paste(deparse(substitute(body_acc_y)), names(body_acc_y), sep=".")
names(body_acc_z)<-paste(deparse(substitute(body_acc_z)), names(body_acc_z), sep=".")

names(body_gyro_x)<-paste(deparse(substitute(body_gyro_x)), names(body_gyro_x), sep=".")
names(body_gyro_y)<-paste(deparse(substitute(body_gyro_y)), names(body_gyro_y), sep=".")
names(body_gyro_z)<-paste(deparse(substitute(body_gyro_z)), names(body_gyro_z), sep=".")

names(total_acc_x)<-paste(deparse(substitute(total_acc_x)), names(total_acc_x), sep=".")
names(total_acc_y)<-paste(deparse(substitute(total_acc_y)), names(total_acc_y), sep=".")
names(total_acc_z)<-paste(deparse(substitute(total_acc_z)), names(total_acc_z), sep=".")

names(activity_labels)<-paste(deparse(substitute(activity_labels)), names(activity_labels), sep=".")
names(subject)<-"subject"


##### bind 

activity_set<-cbind(activity_set, 
                    body_acc_x,body_acc_y,body_acc_z,
                    body_gyro_x,body_gyro_y,body_gyro_z,
                    total_acc_x, total_acc_y, total_acc_z)

str(activity_set)

######################################################################################
# Step 3.Uses descriptive activity names to name the activities in the data set
######################################################################################

activity_set<-merge(activity_labels,activity_set, by.x = "activity_labels.V1", by.y = "activity")

######################################################################################
# Step 2.Extracts only the measurements on the mean and standard deviation for each measurement.
######################################################################################

# create a column index
ind <- grep("mean()|std()", colnames(activity_set))
ind_not <- grep("meanFreq()", colnames(activity_set))

# filter columns
activity_subset<-activity_set %>%
  select(2,3,ind,-ind_not)


######################################################################################
# Step 5.From the data set in step 4, creates a second, independent tidy data set 
#        with the average of each variable for each activity and each subject.
######################################################################################

mean_set <- activity_subset %>%
  group_by(activity_labels.V2,subject)%>%
  summarise_all(mean)

write.table(mean_set,file="Output.txt", row.names = FALSE)
