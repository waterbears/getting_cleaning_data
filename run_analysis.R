# for full data set to -1
read.nrows <- -1

# meta data
feat.names <- read.csv('features.txt', sep='', header=F)
activity.labels <- read.csv('activity_labels.txt', sep='', header=F)

# load the data
X.train <- read.csv('train/X_train.txt', sep='', header=F, nrows=read.nrows)
Y.train <- read.csv('train/y_train.txt', header=F, nrows=read.nrows)
subject.train <- read.csv('train/subject_train.txt', header=F, nrows=read.nrows)
X.test <- read.csv('test/X_test.txt', sep='', header=F, nrows=read.nrows)
Y.test <- read.csv('test/y_test.txt', header=F, nrows=read.nrows)
subject.test <- read.csv('test/subject_test.txt', header=F, nrows=read.nrows)

# merge train/test data
X <- rbind(X.train, X.test)
Y <- rbind(Y.train, Y.test)
subject <- rbind(subject.train, subject.test)

# apply meta data
names(X) <- feat.names[, 2]
names(Y) <- c('act')
names(subject) <- c('sub')
Y$act <- factor(Y$act, levels=activity.labels[, 1], labels=activity.labels[, 2])
subject$sub <- factor(subject$sub)

# feat mean and var
tidy1 <- rbind(sapply(X, mean), sapply(X, sd))
rownames(tidy1) <- c('mean', 'sd')
tidy1 <- t(tidy1)
write.csv(tidy1, file='feat.mean.sd.csv')

# create 
X$sub <- subject$sub
X$act <- Y$act
sub.act.feat.mean <- t(dcast(melt(X, id=c('sub', 'act')), act * sub ~ variable, mean))
write.csv(sub.act.feat.mean, file='subject.activity.feat.mean.csv')