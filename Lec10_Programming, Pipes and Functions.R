# Load packages and datasets
library(tidyverse) # loads the %>% pipe

################################################## Exercise 1 ###########################################################
# Debug the following code

# read_csv("API_ILO_country_YU.csv") %>%
#   gather(year,`Unemployment Rate`,`2010`:`2014`,convert=TRUE) %>%
#   filter(str_detect(`Country Name`," \\(IDA.*\\) %>%
# mutate(`Country Name` =
# str_replace(`Country Name`,"", "\\(IDA.*\\)")) %>%
# select(-`Country Code`) %>%
# ggplot(aes(x=year,y=`Unemployment Rate`, color=`Country Name`)) %>%
# + geom_point() + geom_line()

read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec10_API_ILO_country_YU.csv") %>%
  gather(year,`Unemployment Rate`,`2010`:`2014`,convert=TRUE) %>%
  filter(str_detect(`Country Name`," \\(IDA.*\\)")) %>%
  mutate(`Country Name` = str_replace(`Country Name`,"\\(IDA.*\\)", "")) %>% 
  select(-`Country Code`) %>%
  ggplot(aes(x=year,y=`Unemployment Rate`, color=`Country Name`)) %>% + geom_point() + geom_line()

# Other Tools from magrittr
# %$% is similar to the base R function with()
library(magrittr)
mtcars %$% cor(disp,mpg)
with(mtcars,cor(disp,mpg))
# cor(mtcars$disp, mtcars$mpg)

# Boston dataset
Boston <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec10_Boston.csv")
Boston

# Standardize columns of Boston
Boston$crim <- (Boston$crim - mean(Boston$crim, na.rm=TRUE))/
  sd(Boston$crim,na.rm=TRUE)
Boston$zn <- (Boston$zn - mean(Boston$zn, na.rm=TRUE))/
  sd(Boston$zn,na.rm=TRUE)
Boston$indus <- (Boston$indus - mean(Boston$indus, na.rm=TRUE))/
  sd(Boston$indus,na.rm=TRUE)
# Etc.

# A standardization function
standardize <- function(x) {
  (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)
}
Boston$crim <- standardize(Boston$crim)
Boston$zn <- standardize(Boston$zn)
# Etc

# Components of a function
# three essential components:
# 1. the code inside the function, or body,
# 2. the list of arguments to the function, and
# 3. a data structure called an environment 
#which is like a map to the memory locations of all objects defined in the function.

f <- function(x) {
  x^2
}
f

# The function arguments
# Function arguments can have default values
f <- function(x=0) { x^2}
f()

################################################## Exercise 2 ###########################################################
# Re-write our standardize() function to have an additional argument na.rm, set to TRUE by default.
standardize <- function(x, na.rm = TRUE){
  (x - mean(x, na.rm = na.rm))/sd(x, na.rm = na.rm)
}

# Argument defaults
# Argument defaults can be defined in terms of other arguments
f <- function(x=0,y=3*x) { x^2 + y^2 }
f()
f(x = 1)
f(y = 1)

# Argument matching
f <- function(firstarg, secondarg){
  firstarg^2 + secondarg
}
f(firstarg = 1, secondarg = 2)
f(s = 2, f = 1)
f(2, f = 1)
f(1,2)

# The function body
f <- function(x=0) { x^2}
f <- function(x=0) { return(x^2)}

# Control Flow

# if and if-else
if("cat" == "dog") {
  print("cat is dog")
}else {
  print("cat is not dog")
}

# for loops
n <- 10; nreps <- 100; x <- vector(mode = "numeric", length = nreps)
for(i in 1:nreps) { # or i in seq(nreps)
  x[i] <- mean(rnorm(n))
}
summary(x)
print(i)

################################################## Exercise 3 ###########################################################
# Write a function standardize_tibble() that loops through the columns of a tibble and standardizes each 
#with your standardize() function. 
# (Hints: If tt is a tibble, ncol(tt) is the number of columns, and 1:ncol(tt) is an appropriate index set. 
#If tt is a tibble, tt[[1]] is the first column.)
standardize_tibble <- function(tt) {
  for(i in 1:ncol(tt)) {
    tt[[i]] <- standardize(tt[[i]])
  }
  return(tt)
}
Boston <- standardize_tibble(Boston)

# for loop index set
ind <- c("cat","dog","mouse")
for(i in seq_along(ind)) {
  print((paste("There is a",ind[i],"in my house")))
}

for(i in ind) {
  print(paste("There is a",i,"in my house"))
}

# while loops
set.seed(1)
# Number of coin tosses until first success (geometric distn)
p <- 0.1; counter <- 0; success <- FALSE
while(!success) {
  success <- as.logical(rbinom(n=1,size=1,prob=p))
  counter <- counter + 1
}
counter

# break
for(i in 1:100) {
  if(i>3) break
  print(i)
}

# The function environment
f <- function(x) {
  y <- x^2
  ee <- environment() # Returns ID of environment w/in f
  print(ls(ee)) # list objects in ee
  ee
}
f(1) # function call

# Enclosing environments
search()

################################################## Exercise 4 ###########################################################
# Consider the following code chunk (which you should enter into your RStudio console).
# What is the output of the function call f(5)?     # 36                          
# What is the enclosing environment of f()?         # global environment
# What is the enclosing environment of g()?         # f()
# What search order does R use to find the value of x when it is needed in g()? 
  # first the environment of g(), then the environment of f(), and then .GlobalEnv
x <- 1
f <- function(y) {
  g <- function(z) {
    (x+z)^2
  }
  g(y)
}
f(5)

################################################## Exercise 5 ###########################################################
# Create an R script that first defines standardize_tibble() and then standardize(). 
# In standardize(), replace mean() by a function center() and sd() by a function spread(), 
# where center() and spread() are functions that you write to compute the mean and SD using only the sum() function. 
# center() and spread() should remove missing values by default.
standardize_tibble <- function(tt) {
  standardize <- function(x) {
    center <- function(y, na.rm = TRUE) { 
      n <- length(y)
      return(sum(y, na.rm = na.rm)/n)
    }
    spread <- function(z, na.rm = TRUE) {
      n <- length(z)
      m <- center(z)
      sq_err <- (z-m)^2
      sum_sq_err <- sum(sq_err, na.rm = na.rm)
      return(sqrt(sum_sq_err/(n-1)))
    }
    return((x - center(x))/spread(x))
  }
  for(i in 1:ncol(tt)) {
    tt[[i]] <- standardize(tt[[i]])
  }
  return(tt)
}

exercise5 <- standardize_tibble(Boston)


# R packages
# install.packages("hapassoc")
library(hapassoc)
search()

# Detaching packages
detach("package:hapassoc")
search()

# Package namespaces
set.seed(321)
n<-30; x<-(1:n)/n; y<-rnorm(n,mean=x); ff<-lm(y~x)
car::sigmaHat(ff)


