# load packages
library(tidyverse)
library(gapminder)
library(dplyr)
library(nycflights13)

head(flights)

# filter rows with filter()
gm07 <- filter(gapminder,year==2007)
# gm07 now contains the rows of gapminder in which the variable year is equal to 2007

# relational (comparison) operators
?Comparison
2>3 
2/2==1 
sqrt(2)^2==2      # watch out for finite-precision arithmetic
near(sqrt(2)^2,2) 
# near().
#This is a safe way of comparing if two vectors of floating point numbers are (pairwise) equal. 
#This is safer than using ==, because it has a built in tolerance Usage

# logical operators
# order (! & |)
!TRUE
TRUE | FALSE & FALSE
(TRUE | FALSE) & FALSE # eval parenthess first

# relational comparisons can be combined with logicals
(2==2) | (2==3)

# logical operations between vectors and element-wise
x <-c(TRUE,TRUE,FALSE) 
y <-c(FALSE,TRUE,TRUE)
!x
x&y
x|y

# filter() example
# Extract all flights from January, with departure delay of more than 1:
jan13 <- filter(flights, month==1 & dep_delay>1)

################################################## Exercises ###########################################################
# First, extract all flights from January or February.
#Then extract all flights from January or February that have a
#departure delay of 1 or more.
filter(flights, month==1 | month==2)
filter(janfeb13, dep_delay>=1)

# many logicals and %in%
# lab2
hiv <- read.csv("D:/Simon Fraser University/2020 fall/STAT 261/lab2/HIVprev.csv",stringsAsFactors = FALSE)
cc <- c("Botswana","Central African Republic","Congo","Kenya","Lesotho","Malawi",
        "Nambia","South Africa","Swaziland","Uganda","Zambia","Zimbabwe")
hihiv <- filter(hiv,Country %in% cc)

################################################## Exercises ###########################################################
# The nycflights13 package includes a table
#airlines that translates the two-letter airline codes in
#flights into the full names of the airlines. Extract all flights
#operated by United, American or Delta.
filter(flights, carrier %in% c("AA", "DL", "UA"))

# Missing data:NA (not available)
# precendence (all comparison and arithmetic, almost all logical operations)
NA > 3
NA + 10 
NA & TRUE
NA | TRUE

# Test for NA with is.na()
vv <- c(10,NA,1)
is.na(vv)
vv>1
is.na(vv)|vv>1
################################################## Exercise ############################################################
# Extract all flights from January with missing
#departure delay.
filter(flights,month==1 & is.na(dep_delay))

# Sorting with arrange()
vv <- tibble(x=c(NA,10,10,1),y=c("one","two","three","four"))
arrange(vv,x)
arrange(vv,x,y)

# descending order desc()
arrange(vv,desc(x))
# Exercise: Arrange the mpg data set by decreasing order in the
#number of cylinders (variable cyl) and increasing order by
#engine displacement (variable displ) within cylinders.
arrange(mpg,desc(cyl),displ)

# Selecting columns with select()
select(flights,month,day,hour,minute)

# Select or de-select a range of columns with :
select(flights,month:minute)      # select
select(flights,-(month:minute))   # deselect

# rename variables use rename()
flights <- rename(flights,tail_num=tailnum)

# select() helper functions 
?select
select(flights,contains("dep"))
# Exercise Select all variables with ¡°dep¡± or ¡°arr¡± in the name.
select(flights,contains("dep"), contains("arr"))

# Add new variables with mutate()
gapminder <- mutate(gapminder,log10GdpPercap=log10(gdpPercap))
flights <- mutate(flights,gain=arr_delay-dep_delay, gainh=gain/60)
# If you only want to keep the new variables, use transmute()
(transmute(flights,gain,gainh))

# Summaries and grouping 
by_day <- group_by(flights,year,month,day)
summarise(by_day,delay = mean(dep_delay,na.rm=TRUE))

# Combining operations with the pipe 
select(flights,month,day,dep_delay) %>%
  group_by(month,day) %>%
  summarise(count =n(), delay=mean(dep_delay,na.rm=TRUE))
          