# Load packages and datasets
library(tidyverse)


# Types of objects
x <- 6 # stores as double by default
typeof(x)

y <- 6L # The "L" suffix forces storage as integer
typeof(y)

# Type versus Mode
mode(x)
mode(y)

# More on numeric variables
sqrt(2)^2 - 2
# doubles inlude NaN, Inf, and -Inf for division by zero
c(-1,0,1)/0
# Question: What does NA/0 return? Why does this make sense?
NA/0 # NA

# Creating Vectors
# help("vector")
avec <- vector(mode = "numeric", length = 4)
lvec <- vector(mode = "list", length = 4)

# Creating vectors with c() and list()
avec <- c(36,150,175)
lvec <- list(36,150,175,c("brown", "medium"))

# Combining vectors
c(avec,c(100,101))
c(lvec, TRUE)

# Examples of vector type and length
typeof(avec)
length(avec)
str(avec)
typeof(lvec)
length(lvec)
str(lvec)

# Named vectors
# assigned after the vector has been created
names(lvec) = c("age","weight","height","hair")
str(lvec)
# in the process of creating the vector
lvec <- list(age = 36, weight = 150, height = 175, hair = c("brown","medium"))

# NULL
typeof(NULL)
length(NULL)

################################################## Exercise 1 ###########################################################
# Write a function append1() that takes an argument n. The function body should 
# (i) initialize an object x to NULL, 
# (ii) loop from i in 1 to n and at each iteration use c(x,i) to extend x by one element, and 
# (iii) return x. 
# Use the system.time() function to time append1().  In particular, compare the following:
append1 <- function(n){
  x <- NULL
  for (i in 1:n){x <- c(x,i)}
  return(x)
}

system.time({x <- append1(10000)})
system.time({x <- 1:10000})

# Subsetting vectors
lvec[c(1,3)]
lvec[c("age","height")]
lvec[-2]
lvec[c(TRUE,FALSE,TRUE,TRUE)]

# Extracting vector elements
avec[[2]]
lvec[[4]]
lvec$hair

################################################## Exercise 2 ###########################################################
# How would you extract 150 from lvec? 
lvec[[2]]
lvec$weight
# How would you extract the sub-list containing weight and height data from lvec? 
lvec[c(2,3)]
lvec[c(FALSE,TRUE,TRUE,FALSE)]
# How would you extract brown from lvec?
lvec$hair[[1]]
lvec[[4]][[1]]

# Subsetting and assignment
avec
avec[1:2] <- c(37,145)
avec

# Assignment and lists
lvec[3:4] <- c("Hi","there")
lvec[3:4]
# Assignment with [ requires that the replacement element be of length 1;
lvec[4] <- c("All","of","this")
lvec[4] # Only used first element of replacement vector
# [[ does not have this restriction
lvec[[4]] <- c("All","of","this")
lvec[3:4]

# Coercion: atomic vectors to lists
avec = c(age=36,weight=150,height=175)
avec
as.list(avec)

################################################## Exercise 3 ###########################################################
# The function as.vector() coerces objects to vectors. Why doesn¡¯t as.vector(lvec) appear to do anything?
lvec
as.vector(lvec)

# Coercion: lists to atomic vectors
unlist(lvec)

# Test functions
# is_logical(), is_numeric(), is_character(), is_list() and is_vector()
is_numeric(avec)

# Recycling
x <- rep(100,10)
y <- 1:3
x + y

# Generic functions
print

# Methods for print()
methods("print")[1:10]

# Seeing methods with getS3method()
getS3method("print","default")

# Defining your own class
class(lvec) <- "prof"
print.prof <- function(p){
  cat("The prof is", p$age, "years old, and weights", p$weight, "pounds.\n")
}
print(lvec)

################################################## Exercise 4 ###########################################################
# Create a list of information on this class. The list should have named elements to hold the following information:
# class day         Tuesday
# class start       12:30pm
# class end         2:20pm
# final exam        2020/12/18 3:30pm
# text book         R for Data Science

exercise4 <- list(`class day` = "Tuesday", 
                  `class start` = parse_time("12:30pm", format = "%I:%M %p"), 
                  `class end` = parse_time("2:20pm", format = "%I:%M %p"), 
                  `final exam` = parse_datetime("2020/12/18 3:30pm", format = "%Y/%m/%d %I:%M %p"),
                  `text book` = "R for Data Science")

# Use dates or date-times for the times and date-times in the above. 
# Assign class SFUcourse to the list. 
# Write a function diff.SFUcourse() that takes an object of class SFUcourse as input and 
# returns the duration of the lecture. (Here ¡°duration¡± is as discussed in Lecture 9: Factors, Dates and Times.)
class(exercise4) <- "SFUcourse"
diff.SFUcourse <- function(SFUcourse){
  return(SFUcourse$`class end`- SFUcourse$`class start`)
}
diff(exercise4)

#
library(lubridate)
Stat260 <- list(day="Tuesday",
                start=hm("12:30"), 
                end = hm("14:20"),
                `final exam` = ymd_hm("20191207 12:00"),
                `text book` = "R for Data Science") 
class(Stat260) <- "SFUcourse" 
diff.SFUcourse <- function(x) {return(as.duration(x$end - x$start))}
diff(Stat260)

# Augmented vectors
ff <- factor(c("a","b","c"))
typeof(ff)
attributes(ff)

# Data frames and tibbles
x <- tibble(a=1:3,b=6:8)
attributes(x)










