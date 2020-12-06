library(tidyverse)

setwd("D:/Simon Fraser University/2020 fall/STAT 261/lab11")
dfiles <- dir("Lab11Data", full.names = TRUE)
dfiles

# 1. Write R code to read in the first file. Print the tibble that you just read in. Use names() to change the
#column names of the tibble to x and y. Repeat for the second file. How many observations are in these
#first two files?
study1 <-read_csv("Lab11Data/study1.csv")
names(study1)[1] <- "x"
names(study1)[2] <- "y"

study2 <-read_csv("Lab11Data/study2.csv")
names(study2)[1] <- "x"
names(study2)[2] <- "y"

# Solution
f <- read_csv(dfiles[1])
names(f) <- c("x", "y")

f <- read_csv(dfiles[2])
names(f) <- c("x", "y")


# 2. Use vector() to create an empty vector called ff that is of mode ¡°list¡± and length 9. Now write a
#for() loop to loop over the 9 files in dfiles and for each 
# (i) read the file in to a tibble, and change the column names to x and y as in part (1), and 
# (ii) copy the tibble to an element of your list ff.
ff <- vector(mode = "list", length = 9)

for (i in 1:9){
  study_data <- read_csv(paste0("Lab11Data/study",i,".csv"))
  names(study_data)[1] <- "x"
  names(study_data)[2] <- "y"
  ff[[i]]<- study_data
}

# Solution
ff <- vector(mode="list",length=9)
for(i in seq_along(ff)) {
  f <- read_csv(dfiles[i])
  names(f) <- c("x","y")
  ff[[i]] <- f
}


# 3. Write a function called read.study_data that takes a vector of data file names (like dfiles) as input,
#reads the data files into a list, assigns class ¡°study_data¡± to the list, and returns the list. Your function
#should use length(dfiles) to determine the number of files.
read.study_data <- function(dfiles){
  ff <- vector(mode = "list", length = 9)
  for (j in 1:length(dfiles)){
    study_data <- read_csv(paste0("Lab11Data/study",j,".csv"))
    names(study_data)[1] <- "x"
    names(study_data)[2] <- "y"
    ff[[j]]<- study_data
  }
  class(ff) <- "study_data"
  return(ff)
}

Q3 <- read.study_data(dfiles)

# Solution
read.study_data <- function(dfiles) {
  ff <- vector(mode="list",length=length(dfiles))
  for(i in seq_along(ff)) {
    f <- read_csv(dfiles[i])
    names(f) <- c("x","y")
    ff[[i]] <- f
  }
  class(ff) <- "study_data"
  ff
}
ss <- read.study_data(dfiles)

# 4. Write a function plot.study_data() that takes an object of class ¡°study_data¡± as input. 
# The first 5 lines of your function should be the following, which creates a tibble with columns study, x and y:

# dat <- NULL
# for(i in seq_along(ff)) {
#   d <- ff[[i]]
#   dat <- rbind(dat,tibble(study=i,x=d$x,y=d$y))
# }

# Have your function coerce study to a factor, and then call ggplot() to make a plot of y versus x, with
# different colours for the different studies. Add points and smoothers to your plot.
plot.study_data <- function(ff){
  dat <- NULL
  for(i in seq_along(ff)) {
    d <- ff[[i]]
    dat <- rbind(dat,tibble(study=i,x=d$x,y=d$y))
  }
  dat$study <- factor(dat$study)
  ggplot(data = dat, aes(x = x, y = y, color = study)) + geom_point() + geom_smooth()
}
Q4 <-plot(Q3)
Q4

# Solution
plot.study_data <- function(ff) {
  dat <- NULL
  for(i in seq_along(ff)) {
    d <- ff[[i]]
    dat <- rbind(dat,tibble(study=i,x=d$x,y=d$y))
  }
  dat <- mutate(dat,study=factor(study))
  ggplot(dat,aes(x=x,y=y,color=study)) + geom_point() + geom_smooth()
}
ss <- read.study_data(dfiles)
plot(ss)


