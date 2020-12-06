#'---
#'title: "lab1"
#'author:
#'date:
#'output: pdf_document
#'---

# Use the Tools -> Install Packages menu item in RStudio, then type gapminder, 
# tidyverse into the text box and click Install.

# Exploratory analysis of gapminder data
# Load the gapminder data
library(gapminder)
# dplyr facilitates exploratory analyses
library(dplyr)
# ggplot2 allows visualization
library(ggplot2)

# Take a look at the top and bottom few lines of raw data.
head(gapminder)
tail(gapminder)
summary(gapminder)

# Type help("gapminder") in the R console for information about the gapmider dataset.
help("gapminder")

# We will explore the life expectancy variable for the year 2007. First filter the data to just 2007.
gapminder07 <- filter(gapminder, year == 2007)
head(gapminder07)
# In R, the <- is the assignment operator that creates new variables/datasets.

# Life expectancy by continent
# Calculate median life expectancy, first overall, and then by continent.
summarize(gapminder07, median(lifeExp))

by_cont <- group_by(gapminder07, continent)
summarise(by_cont, median(lifeExp))
# In the above commands, group_by() creates a new data set with observations grouped by continent.

# We can visualize the median life expectancies.
medL <- summarize(by_cont, median(lifeExp))
plot(medL)

# what is "Oceania"?
filter(gapminder07,continent == "Oceania")

# The dplyr package allows for us to "chain" the filter, grouping and summary commands. 
# The following is an equivalent way to construct medL:
medL <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarise(medLifeExp = median(lifeExp))

# Life expectancy over time
# First look at African countries
medLA <- gapminder %>%
  filter(continent == "Africa") %>%
  group_by(country) %>%
  summarise(medLifeExp = median(lifeExp))

# Look at a subset of countries with the lowest and highest median life expectancies.
filter(medLA,medLifeExp<40)
filter(medLA,medLifeExp>60)

cc=c("Angola","Guinea-Bissau","Sierra Leone",
     "Mauritius","Reunion","Tunisia",
     "Mexico") # Mexico for comparison

# Plot life expectancy over time. Illustrate chaining of filtering (on country) and ggplot.
gapminder %>%
  filter(country %in% cc) %>%
  ggplot(aes(x=year,y=lifeExp,color=country)) +
  geom_point() +
  geom_smooth(method = "lm")

# Here's another interesting plot of life expectancy over time:
gapminder %>%
  filter(continent == "Oceania") %>%
  ggplot(aes(x=year,y=lifeExp,color=country)) +
  geom_point() +
  geom_smooth(method = "loess", span=3/4)

# Life expectancy versus per capita GDP
# First try a simple scatterplot of lifeExp versus gdpPercap.
qplot(gdpPercap,lifeExp,data=gapminder07)

# It is hard to make sense of the pattern in lifeExp versus gdpPercap. Try grouping the data by continent.
qplot(gdpPercap,lifeExp,data=gapminder07,color = continent)

# Add regression lines for each continent. Doing so uses a more complicated graphing function from ggplot2.
ggplot(gapminder07, aes(x=gdpPercap,y=lifeExp,color=continent)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
