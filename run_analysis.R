# Needed libraries
library(reshape2)

# Read data
test_X <- read.table("test/X_test.txt")
train_X <- read.table("train/X_train.txt")
test_y <- read.table("test/y_test.txt")
train_y <- read.table("train/y_train.txt")
test_subject <- read.table("test/subject_test.txt")
train_subject <- read.table("train/subject_train.txt")
features <- read.table("features.txt")

# column names
names(test_X) <- features$V2
names(train_X) <- features$V2
names(test_y) <- "activity"
names(train_y) <- "activity"
names(test_subject) <- "subject"
names(train_subject) <- "subject"

# combine all into one dataset
merged <- rbind(cbind(train_subject, train_y, train_X), cbind(test_subject, test_y, test_X))

# remove unused columns
unused <- grepl("mean\\(\\)", names(merged)) | grepl("std\\(\\)", names(merged))
unused[1:2] <- TRUE
merged <- merged[, unused]

# convert to factor
merged$activity <- factor(merged$activity, labels = c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# create and write the tidy dataset
melted <- melt(merged, id = c("subject","activity"))
tidy <- dcast(melted, subject+activity ~ variable, mean)

write.table(tidy, "tidy.txt", row.names = FALSE)
