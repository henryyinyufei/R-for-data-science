library(tidyverse)
library(forcats)
library(lubridate)
yvr <- read_csv("D:/Simon Fraser University/2020 fall/STAT 261/lab9/weatherYVR.csv")

# In the above code chunk you read in daily weather data from YVR in 2003.
# 1. Coerce the Date/Time variable to a date object and rename it Date.
excercise1 <- yvr %>% 
  mutate(`Date/Time` = ymd(`Date/Time`)) %>%
  rename(Date = `Date/Time`)
excercise1

# 2. Make a time series plot (with lines) of the daily maximum temperature by day.
ggplot(excercise1, aes(x = Date, y = `Max Temp`)) + geom_line()

# 3. Change the Month variable from numeric to a factor. 
# (Hint: The month() function with the label=TRUE will extract the months from a date-time object.)
excercise3 <- excercise1 %>% 
  mutate(Month = month(Date, label = TRUE))
excercise3

# 4. Plot the average maximum temperature versus month. 
# Then, redo this plot with months ordered by average maximum.
excercise3 %>% 
  group_by(Month) %>%
  summarize(`Average Maximum Temperature` = mean(`Max Temp`, na.rm = TRUE)) %>%
  ggplot(aes(x = Month, y = `Average Maximum Temperature`)) + geom_point()

excercise3 %>% 
  group_by(Month) %>%
  summarize(`Average Maximum Temperature` = mean(`Max Temp`, na.rm = TRUE)) %>%
  ggplot(aes(x = fct_reorder(Month,`Average Maximum Temperature`), y = `Average Maximum Temperature`)) + geom_point()


       