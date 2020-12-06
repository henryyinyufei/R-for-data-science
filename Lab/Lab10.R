library(tidyverse)

setwd("D:/Simon Fraser University/2020 fall/STAT 261/lab10")
dfiles <- dir("Lab10Data",full.names=TRUE)
dfiles

# 1. Read the first datafile into a tibble named ex_data. Change the name of the res column to experiment1,
#by manipulating the names attribute of ex_data. That is, use names(ex_data)[2] <- "experiment1".
ex_data <- read_csv("Lab10Data/exper1.csv")
names(ex_data)[2] <- "experiment1"

a <- read_csv(dfiles[1])
# 2. Write a function read_ex() that takes dfiles and an experiment number i as arguments and returns
#a tibble with the name of the res column changed to the expermiment number. That is,
#read_ex(dfiles,1) should return the same tibble as in question 1.
read_ex <- function(dfiles, i) {
  ex_data <- read_csv(paste0("Lab10Data/exper",i,".csv"))
  names(ex_data)[2] <- paste0("experiment",i)
  return(ex_data)
}
Q2 <- read_ex(dfiles, 1)

# 3. Use your function from question 2 to read in the second data file. Join this second file to ex_data by ¡®ID'.
Q3 <- ex_data %>% left_join(read_ex(dfiles, 2))

# 
Q3a <- left_join(ex_data,read_ex(dfiles,2))
Q3b <- left_join(ex_data,read_ex(dfiles,2),by="ID")

# 4. Write a function called read_ex_data() that takes a folder name as its argument and
#1. reads in the data filenames from that folder,
#2. calls read_ex() to read the first datafile into ex_data,
#3. loops through the remaining data files, successively joining them to ex_data, and
#4. returns ex_data.
read_ex_data <- function(foldername){
  dfiles <- dir(foldername, full.names = TRUE)
  ex_data <- read_ex(files, 1)
  for(j in 2:9){
    ex_data <- ex_data %>% left_join(read_ex(dfiles, j)) 
  }
  return(ex_data)
}
Q4 <- read_ex_data("Lab10Data")



# 
Q4_func_a <- function(foldername){
  dfiles <- dir(foldername, full.names = TRUE)
  ex_data <- read_ex(files, 1)
  for(i in 2:length(dfiles)){ if(i>1) { ex_data <- left_join(ex_data,read_ex(dfiles,i)) } }
  return(ex_data)
}

Q4_func_b <- function(foldername){
  dfiles <- dir(foldername, full.names = TRUE)
  ex_data <- read_ex(files, 1)
  for(i in seq_along(dfiles)){ if(i>1) { ex_data <- left_join(ex_data,read_ex(dfiles,i)) } } 
  return(ex_data)
}
Q4a <- Q4_func_a("Lab10Data")
Q4b <- Q4_func_b("Lab10Data")
