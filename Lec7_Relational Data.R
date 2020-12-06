# Load packages and datasets
library(tidyverse)
library(nycflights13)
# Example from http://www.itl.nist.gov/div897/ctg/dm/sql_examples.htm
station <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec07station.csv",
                    col_types = cols(ID = col_integer()))
stats <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec07stats.csv",
                  col_types = cols(ID = col_integer()))

# Multiple tables
station
stats

# The nycflights13 Relational Data
print(airlines,n=3)
print(airports,n=3)
print(planes,n=3)
print(weather,n=3)

################################################## Exercise #############################################################
# The relationship between the weather and airports tables is not shown on the diagram. What is it?
# The column airports$faa is a foreign key of weather$origin.

# Tables with no Primary Key
flights %>%
  count(year,month,day,flight,tailnum) %>%
  filter(n > 1) %>% print(n=3)

################################################## Exercise #############################################################
# Select year, month, day, flight and tailnum from flights and add a surrogate key to this 5-column table.
flights %>%
  select(year,month,day,flight,tailnum) %>%
  mutate(flight_id = row_number())

# Textbook solution
flights %>%
  arrange(year, month, day, sched_dep_time, carrier, flight) %>%
  mutate(flight_id = row_number()) %>%
  glimpse()

# Joining Tables
stats %>% left_join(station)

# Inner Joins
station <- station[-3,]
stats %>% left_join(station)
# The inner-join keeps observations that appear in both tables.
stats %>% inner_join(station)

# Left-Joins with nycflights13
flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

# Natural Join of weather
flights2 %>% left_join(weather)

# by = X
flights2 %>% left_join(planes, by = "tailnum")

# Matching Keys with Different Names
flights2 %>% left_join(airports, by = c("dest" = "faa"))

################################################## Exercise #############################################################
# Change the name of the ID column in stats to Station.
# With these modified tables, do a left-join of the stats and station tables.
stats %>% 
  rename(Station = ID) %>% 
  left_join(station, by = c("Station" = "ID"))

# Filtering Joins 
top_dest <- flights2 %>% count(dest, sort=TRUE) %>% head(n=10)
print(top_dest, n=4)
# The "old" way 
flights2 %>% filter(dest %in% top_dest$dest) %>% print(n=4)
# semi-join way
flights2 %>% semi_join(top_dest) %>% print(n=4)

################################################## Exercise #############################################################
# From the original flights table, create a table called top_dep_delay comprised of the year-month-days with the 3
#largest total delays, where total delay is defined as the sum of the dep_delay variable for each year-month-day.
# Hints: 
#use group_by() to group flights by year-month-day;
#use summarize() to compute total delays (watch out for missing values); 
#use arrange() to sort on your total delays variable (you want to sort in descending order)
top_dep_delay <- group_by(flights, year,month,day) %>%
  summarize(total_dep_delay = sum(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(total_dep_delay)) %>%
  head(n=3)
# Do a semi-join to filter flights to these days
flights %>% semi_join(top_dep_delay)

# Set Operations : intersect(), union(), setdiff().
v1 <- c("apple","pen","pineapple"); v2 <- c("apple","orange","grape")
intersect(v1,v2)
union(v1,v2)
setdiff(v1,v2)

df1 <- tibble(x=c(1,2),y=c(1,1)); df2 <- tibble(x=c(1,1),y=c(1,2))
intersect(df1,df2)
union(df1,df2)
setdiff(df1,df2)

# Case Study: TB Map
tb <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/lec06tb.csv") %>%
  select(-new_sp, -contains("04"), -contains("514"), -new_sp_mu, -new_sp_fu) %>%
  gather(new_sp_m014:new_sp_f65, key = demog, value = count, na.rm = TRUE) %>%
  mutate(demog = substr(demog, 8, 12)) %>%
  separate(demog, into=c("gender", "agecat"), sep = 1)

tb2 <- tb %>% spread(key = gender, value = count) %>%
  mutate(count = m+f) %>%
  select(-m,-f) %>%
  filter(!is.na(iso2))

# Use map data from the maps package
library(maps)
ww <- as_tibble(map_data("world")) %>%
  mutate(iso2 = iso.alpha(region))
ww

# Extract TB data on children in 2000 and join to ww.
tbchild00 <- tb2 %>%
  filter(agecat == "014", year == 2000) %>%
  select(iso2,count)
wwchild00 <- ww %>% left_join(tbchild00)

# Can¡¯t distinguish countries on the count scale, so transform to log-count (plus 1 to avoid log of 0).
ggplot(wwchild00, aes(x = long, y = lat, fill = log(count+1), group = group)) +
         geom_polygon() +
         coord_quickmap()

       