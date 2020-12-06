# Load packages and datasets
library(tidyverse)
table1 <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec06table1.csv",
                   col_types = cols(
                     country = col_character(),
                     year = col_integer(),
                     cases = col_integer(),
                     population = col_integer()
                   ))

# Create tibbles used in examples
table2 <- table1 %>%
  gather(cases,population,key="type",value="count") %>%
  arrange(country,year)

table3 <- table1 %>%
  mutate(rate = paste(cases,population,sep="/")) %>%
  select(-cases,-population)

table4a <- table1 %>%
  select(country,year,cases) %>%
  spread(key=year,value=cases)

table4b <- table1 %>%
  select(country,year,population) %>%
  spread(key=year,value=population)

# Tidy data
table1

# Non-tidy data
################################################## Exercise ############################################################
# Why are table2 and table4a not tidy?
print(table2, n=6)
print(table4a, n=6)
# cases and population are what we measure on the observational unit and so must be variables.

# 
table1 %>% mutate(rate=cases/population*10000)
table1 %>% group_by(year) %>% summarize(sum(cases))
ggplot(table1, aes(x=year,y=cases,color=country)) + geom_point()

################################################## Exercises ###########################################################
# Compute rate from table2.
# Table 2: First, create separate tables for cases and population and ensure that they are sorted in the same order.
t2_cases <- filter(table2, type=="cases") %>%
  rename(cases = count) %>%
  arrange(country,year)
t2_population <- filter(table2, type=="population") %>%
  rename(population = count) %>%
  arrange(country,year)
# Then create a new data frame with the population and cases columns, and calculate the cases per capita in a new column
t2_cases_per_cap <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population
) %>%
  mutate(cases_per_cap = cases/population * 10000) %>%
  select(country,year,cases_per_cap)
# To store this new variable in the appropriate location, we will add new rows to table2
t2_cases_per_cap <- t2_cases_per_cap %>%
  mutate(type = "cases_per_cap") %>%
  rename(count = cases_per_cap)
bind_rows(table2, t2_cases_per_cap) %>%
  arrange(country,year,type,count)

# For table4a and table4b, create a new table for cases per capita, which we¡¯ll name table4c, 
#with country rows and year columns.
table4c <- 
  tibble(
    country = table4a$country,
    `1999` = table4a[["1999"]]/table4b[["1999"]] *10000,
    `2000` = table4a[["2000"]]/table4b[["2000"]] *10000
  )
table4c

# Gathering
table4a %>% gather(`1999`,`2000`,key=year,value=cases)
################################################## Exercise ############################################################
# Repeat for table4b
table4b %>% gather(`1999`,`2000`,key=year,value=population)

# Gathering: another example
bb <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec06billboard.csv")
bb
# Select and rename
bb <-
  bb %>% select(-time,-genre) %>%
  rename(artist = artist.inverted)
# Gather the weeks into a ¡°long¡± version of the Billboard data
bb %>% gather(x1st.week:x76th.week, key=week, value=rank, na.rm=TRUE) %>%
  mutate(week = parse_number(week)) %>% # replace, e.g., x1st.week with 1, ...
  arrange(artist,track,week)

# Spreading
table2
table2 %>% spread(key=type,value=count)
################################################## Exercise ############################################################
# Select country, year and cases from table1 and use spread to obtain
#a table with rows for each year and columns for each country. (Note: such data
#is not tidy.)
table1 %>% 
  select(country,year,cases) %>%
  spread(key=country,value=cases)
# gather it back
table1 %>% 
  select(country,year,cases) %>%
  spread(key=country,value=cases) %>% 
  gather(`Afghanistan`,`Brazil`,`China`,key=country,value=cases) %>%
  select(country,year,cases)

# Separating
print(table3,n=4)
table3 %>% separate(rate,into=c("cases","population"),sep="/") %>% print(n=4)
# Separating based on character number
print(table3,n=4)
table3 %>% separate(rate,into=c("first","remainder"),sep=1)
# Convert type of columns after separating
table3 %>% separate(rate,into=c("cases","population"),sep="/",
                               convert=TRUE)

# Unite
table3 %>% separate(rate,into=c("cases","population"),sep="/") %>%
  unite(rate,cases,population,sep="/")

# Missing data
bb %>% select(track,x23rd.week:x25th.week) %>% print(n=4) # "explicit" missing data
# when gather() removes them they become ¡°implicit¡± (e.g., no row for week 25 for track 4).
# Making implicit missing data explicit
stocks <- tibble( year=c(2015,2016,2016), qtr = c(1,1,2),
                  return = c(1.0,2.0,3.0))
stocks
# spread() will make implicit missing values explicit if needed for a row.
stocks %>% spread(key=year,value=return)
# Make implicit explicit with complete()
stocks %>% complete(year,qtr)

# Case Study: WHO TB data
tb <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec06tb.csv")
names(tb)[1:10]
# Remove variables
tb <- select(tb,-new_sp, -contains("04"), -contains("514"),
             -new_sp_mu, -new_sp_fu)
tb
# Gather counts for demographic groups
tblong <- tb %>%
  gather(new_sp_m014:new_sp_f65,key=demog,value=count,na.rm=TRUE)
tblong
# Separate gender from age category.
maxlen <- max(nchar(tblong$demog))
tb <- tblong %>% mutate(demog= substr(demog,8,maxlen)) %>%
  separate(demog,into=c("gender","agecat"),sep=1)
tb


# Case Study from online textbook
who
who %>% 
  gather(new_sp_m014:newrel_f65,key=key,value=cases,na.rm=TRUE) %>%
  mutate(key = str_replace(key, "newrel", "new_rel")) %>%
  separate(key,into=c("new","type","sexage"),sep="_") %>%
  select(-new,-iso2,-iso3) %>%
  separate(sexage,into=c("sex","age"),sep=1)
