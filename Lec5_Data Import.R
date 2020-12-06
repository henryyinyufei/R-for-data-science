# loading package
library(tidyverse)
library(nycflights13)

# dataframe
dd <- data.frame(x=c(NA,10,1),y=c("one","two","three"))
dd
# tibbles
tt <- tibble(x=c(NA,10,1),y=c("one","two","three"))
tt
# data frames to tibbles and back
as_tibble(dd)
as.data.frame(tt)

# tibble printing
flights

# control printing of tibbles
view(flights)
# setting options (dplyr.print_min=Inf and tibble.width=Inf)  

# extracting columns as vectors 
dd$x
tt$x
dd[["x"]]
tt[["x"]]

# subsetting: columns
# select() preferred method
tt[,"x"]
tt[,c("x","y")]
dd[,"x"] # returns a vector
dd[,c("x","y")]

# subsetting: rows
# filter() preferred method
tt[2,]
tt[1:2,]
dd[2,]
dd[1:2,]

################################################## Exercise ############################################################
# Create a data frame myd and tibble myt that each have 
#columns named cat, dog and mouse. Each column should be
#of length three, but the values in each column are up to you
myd <- data.frame(cat=c(1,2,3),dog=c(4,5,6),mouse=c(7,8,9))
myd
myt <- tibble(cat=c(1,2,3),dog=c(4,5,6),mouse=c(7,8,9))
myt
# What do names(myd) and names(myt) return?
names(myd)
# [1] "cat"   "dog"   "mouse"
names(myt)
# [1] "cat"   "dog"   "mouse"
# Create the variable a1 <- c("cat","dog","bird","fish")
#and the variable a2 <- c("cat","tiger"). We can combine
#logicals with [ to subset. What do the following return?
a1 <- c("cat","dog","bird","fish")
a2 <- c("cat","tiger")
myd[,names(myd) %in% a1]
myd[,names(myd) %in% a2] # returns a vector
myt[,names(myd) %in% a1]
myt[,names(myd) %in% a2]

# importing data
hiv <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/HIVprev.csv")

# other read_function 
#read_csv2()   (semicolon-delimited files)
#read_tav()    (tab-delimited files)
#read_delim()  (user-specified delimiter, delim="")

################################################## Exercise ############################################################
# A file called ¡°chicken.C¡± contains the following data
#on two chickens, with IDs 22 and 33, who laid 2 and 1 eggs,
#respectively. (Reference: https://isotropic.org/papers/chicken.pdf) How
#would you read this data file into R?
read_delim("IDCeggs\n22C2\n33C1",delim="C")

# Reading example into R with read_csv()
read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec05exfile.csv",skip=2,comment="#")

# Parsing a vector 
parse_number(c("$10.55","33%","Number is 44","."),na=".")

# Other parsing functions (Use the str() function to see the mode of an object)
str(parse_logical(c("TRUE","FALSE")))
str(parse_logical(c("1","0")))
str(parse_integer(c("1","0")))
str(parse_double(c("1","0")))
str(parse_factor(c("1","0")))

# dates and times
help(strptime) # the formatting rules are described

dd <- c("05/14/1966/12/34/56","04/02/2002/07/43/00","08/17/2005/07/22/00",
        "08/12/2008/16/20/00")
dd <- parse_datetime(dd,format = "%m/%d/%Y/%H/%M/%S")
str(dd)
mean(dd)
diff(dd)

# Parsing files
dat <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec05exfile.csv",skip=2,comment="#")
# Cut-and-paste the guess and replace parsers as necessary
dat <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec05exfile.csv",skip=2,comment="#",
                col_types=cols(
                  A = col_integer(),
                  B = col_double(),
                  C = col_date(format = "%Y-%m-%d")
                ))
str(dat$A)

################################################## Exercise ########################################################### 
# Specify the column types yourself, based on the descriptions in the header of the file. Hint: read about col_factor().
exercise <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec05Exercise.csv",skip=1,comment="#")
exercise <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec05Exercise.csv",skip=1,comment="#",
                     col_types=cols(
                       fert = col_factor(),
                       date = col_datetime(format= "%Y/%m/%d/%H/%M"),
                       yield = col_double()
                     ))
str(exercise)
exercise
