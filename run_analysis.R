samsung<-function(){
setwd("C:/Users/Ewa/Documents/Rprogramming/UCI HAR Dataset/test")
test_X<-read.table("X_test.txt",header=FALSE)
test_X$group<-"test"
labels_test<-read.table("y_test.txt")
test_X<-cbind(test_X,labels_test)
subject_test<-read.table("subject_test.txt")
test_X<-cbind(test_X,subject_test)



setwd("C:/Users/Ewa/Documents/Rprogramming/UCI HAR Dataset/train")
train_X<-read.table("X_train.txt",header=FALSE)
train_X$group<-"train"
labels_train<-read.table("y_train.txt")
train_X<-cbind(train_X,labels_train)
subject_rain<-read.table("subject_train.txt")
train_X<-cbind(train_X,subject_train)

new_data<-rbind(train_X,test_X)


setwd("C:/Users/Ewa/Documents/Rprogramming/UCI HAR Dataset")
features<-read.table("features.txt",header=FALSE)
col_names<-features[,2]
for (i in 1:length(new_data)-3){names(new_data)[i]<-as.character(col_names[i])}
names(new_data)[562]<-"group"
names(new_data)[563]<-"activity"
names(new_data)[564]<-"subject"
subset_names<-names(new_data)[grep(c("mean|std"),names(new_data))]
subset_names<-subset_names[-grep("meanFreq",subset_names)]
merge_subset<-new_data[c(subset_names,"group","activity","subject")]

merge_subset$activity_label<-sapply(merge_subset$activity,function(val) switch(val,
                             "1"="WALKING",
                             "2"="WALKING_UPSTAIRS",
                             "3"="WALKING_DOWNSTAIRS",
                             "4"="SITTING",
                             "5"="STANDING",
                             "6"="LAYING"))
merge_subset$activity<-NULL
merge_subset$group<-NULL
merge_mean<-merge_subset[1:66]
tidy_data <-aggregate(merge_mean, by=list(merge_subset$subject,merge_subset$activity_label),
                      FUN=mean, na.rm=TRUE)
names(tidy_data)[c(1,2)]<-c("subject","activity_label")
write.table(tidy_data,"tidy_data.txt",row.name=FALSE)
return(tidy_data)
}
