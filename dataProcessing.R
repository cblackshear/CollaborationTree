
#loading libraries
library(magrittr)
library(stringr)
library(forcats)
library(plotly)
library(scales)
library(tidyverse)

######################################################step 1##############################################
Data <- read.csv('data/tree.csv', stringsAsFactors = FALSE)
#creating hierarchical structure for tree data, starting at t=0:
treeH <- data.frame(matrix(data=NA,nrow=nrow(Data)*4,ncol=2))
colnames(treeH) <- c('level_num','node_name')

j=1

for ( i in 1:nrow(Data)) {
  t=0
  for (k in 1:5) {
    if (Data[i,k]!= "") {
    treeH$level_num[j] <- t 
    treeH$node_name[j] <- Data[i,k]
    t <- t+1
    j <- j+1
    }
  }
}

# getting complete cases
cc <- (complete.cases(treeH$level_num,treeH$node_name))
treeH <- treeH[cc,]

###################################################step 2##################################################
treenew <- data.frame(matrix(data=NA,nrow=nrow(treeH),ncol=3))
colnames(treenew) <- c('level_num','parent_name','node_name')

for (i in 1:nrow(treeH)){
  if(treeH$level_num[i] == 0){
    treenew$parent_name[i] <- 'No parent_name'
    treenew$node_name[i] <- treeH$node_name[i]
    treenew$level_num[i] <- treeH$level_num[i]
  }
  else {
    treenew$parent_name[i] <- treeH$node_name[i-1]
    treenew$node_name[i] <- treeH$node_name[i]
    treenew$level_num[i] <- treeH$level_num[i]
  }
}

#################################################step 3###################################################
treeFinalnew <- data.frame(table(treenew$parent_name,treenew$node_name))
treeFinalnew <- subset(treeFinalnew, treeFinalnew$Freq >= 1)
colnames(treeFinalnew) <- c('parent_name','node_name','value')
treeFinalnew <- treeFinalnew[,c(2,1,3)]

#################################################step4####################################################

## adding the node_name to dataframe by merging with raw data (just cols email_id and conatact_name) by email_id and node_name
DataSubset <- Data[,5:6]

#removing duplicated rows
DataSubset <- unique(DataSubset)

treeFinalnewMerged <- merge(treeFinalnew,DataSubset, by.x = c("node_name"), by.y = c("email_id"), all.x = T)

# renaming contact_name as email_id
names(treeFinalnewMerged)[4] <- 'email_id'

treeFinalnewMerged$node_name <- as.character(treeFinalnewMerged$node_name)

#replacing the names in node_name with actual contact_name and email in email_id with actual email
for (i in 1:nrow(treeFinalnewMerged)) {
if (!is.na(treeFinalnewMerged$email[i])) {
  
  x <- treeFinalnewMerged$email_id[i]
  y <- treeFinalnewMerged$node_name[i]
  treeFinalnewMerged$node_name[i] <- x
  treeFinalnewMerged$email_id[i] <- y
}
}

#converting the data into json format
library(d3r)
d3_json(treeFinalnewMerged)
