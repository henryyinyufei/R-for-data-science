library(tidyverse)
library(nycflights13)

# 1. Add the latitude and longitude of each airport destination to the flights table using a join function.
#You will find the data on latitude and longitude in the airports table.
excercise1 <- flights %>% 
  left_join(select(airports,faa,lon,lat), by = c("dest" = "faa"))

# 2. Create a table with the year-month-day-flight-tailnum combinations that have more than 1 flight (careful
#about missing tailnum).
excercise2a <- flights %>%
  count(year,month,day,flight,tailnum) %>%
  filter(n > 1, !is.na(tailnum))

#Use this table to filter the flights table and then select carrier, flight, origin and dest.
excercise2b <- flights %>% semi_join(excercise2a) %>%
  select(year:day,carrier, flight, origin, dest) %>% left_join(airlines)

#Which airline used the same flight number for a plane that made a trip from La Guardia to
#St. Louis in the morning and from Newark to Denver in the afternoon? 
# WN Southwest Airlines Co.

# 3. One of the exercises in the lecture 7 notes asked you to create a table called top_dep_delay from the
#flights table. top_dep_delay was comprised of the year-month-days with the 3 largest total delays,
#where total delay is defined as the sum of the dep_delay variable for each year-month-day. 
top_dep_delay <- group_by(flights, year,month,day) %>%
  summarize(total_dep_delay = sum(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(total_dep_delay)) %>%
  head(n=3)

# Recreate top_dep_delay for this lab exercise. For each of the three top-delay days, report the median, third
#quartile and maximum of the dep_delay variable in flights.
excercise3 <- flights %>% semi_join(top_dep_delay) %>%
  group_by(year, month, day) %>%
  summarise(median = median(dep_delay, na.rm = TRUE),
            Q3 = quantile(dep_delay, probs = 0.75, na.rm = TRUE),
            max = max(dep_delay, na.rm = TRUE))









