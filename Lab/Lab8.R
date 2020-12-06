library(tidyverse)
library(stringr)

# Graphing youth unemployment data

# 1. Read the youth unemployment data in the file API_ILO_country_YU.csv, in the Lab8 folder on Canvas,
#into a data frame called youthUI.
youthUI <- read_csv("D:/Simon Fraser University/2020 fall/STAT 261/lab8/API_ILO_country_YU.csv")

# 2. Reshape the data on different years into key-value pairs with key year and value Unemployment Rate.
#Convert the year column to numeric.
youthUI <- gather(youthUI, `2010`:`2014`, key = "year", value = "Unemployment Rate", convert = TRUE)
summarize(youthUI, sd(year))

# 3. Plot unemployment rates by year for each ¡°country¡± in youthUI. Represent each time series by a line.
#Use an appropriate alpha level to manage overplotting.
ggplot(youthUI, aes(x = year, y = `Unemployment Rate`, group = `Country Name`)) + 
  geom_line(alpha = 0.3)

# 4. Using a regular expression, extract the subset of ¡°Countries¡± whose Country Name contains the
#string ¡°(IDA & IBRD countries)¡± or ¡°(IDA & IBRD)¡±, and save in a data frame youthDevel. 
#No cheating by using fixed().

# Hint: ( is a special character string, so a character string representation of a regexp involving ( would include ¡°\\(¡±
#Then, using a regular expression, remove the ¡°(IDA & IBRD countries)¡± or ¡°(IDA & IRBD)¡± from the country names.

# Notes: IDA stands for International Development Association.
#Countries that qualify for IDA loans are considered among the poorest developing countries in the world.
#IBRD stands for International Bank for Reconstruction and Developent.
#IBRD countries are considered middle-income developing countries.

# There are probably several possible regexps you could use. One
# thing to watch for is that there are multiple country names
# that include parentheses, so it is not enough to use "\\(.*\\)".
my_pattern <- " \\(IDA.*\\)"
youthDevel <- filter(youthUI,str_detect(`Country Name`,my_pattern)) %>%
  mutate(`Country Name` = str_replace(`Country Name`,my_pattern,"")) %>%
  select(-`Country Code`)


# 5. Plot unemployment rates by year for each region in youthDevel with different colors for each region.
#Your plot should include both points and lines for each region. Then add a layer that plots the
#world-wide unemployment data from youthUI (Country.Name==World).
wd <- filter(youthUI, `Country Name` == "World")
ggplot(youthDevel, aes(x = `year`, y = `Unemployment Rate`, color = `Country Name`)) +
  geom_point() +
  geom_line() +
  geom_point(data = wd) +
  geom_line(data = wd)
  






