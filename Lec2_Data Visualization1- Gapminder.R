# Example: The gapminder data
library(tidyverse)
library(gapminder)
data(gapminder)
head(gapminder)

# Subsetting the gapminder data
# Plot life expectancy versus GDP per capita for 2007.
gm07 <- filter(gapminder, year==2007)
ggplot(gm07, aes(x=gdpPercap, y=lifeExp, color=continent)) +
  geom_point()

# Transform GDP per capita.
gm07 <- mutate(gm07, log10GdpPercap = log10(gdpPercap))
ggplot(gm07, aes(x=log10GdpPercap, y=lifeExp, color=continent)) +
  geom_point()

# Build a plot by layer
# Set the mapping:
gapminder <- mutate(gapminder, log10GdpPercap = log10(gdpPercap))
p <- ggplot(gapminder, aes(x=log10GdpPercap, y=lifeExp, color=continent))

# Add the geoms, set transparency
p2 <- p + geom_point(alpha=0.1)

# Add statistical transformations
p2 + stat_smooth()

################################################## Exercise #############################################################
#'The variable year is quantitative, but can still be used as a
#'grouping variable. Make scatterplots of lifeExp versus
#'log10GdpPercap with points colored by year. Add a
#'scatterplot smoother with (i) no grouping variable and (ii)
#'year as the grouping variable. Set the SE to FALSE for your
#'smoothers.
gapminder <- mutate(gapminder, log10GdpPercap = log10(gdpPercap))
# i)
ggplot(gapminder,aes(x=log10GdpPercap,y=lifeExp,color=year)) + geom_point() + 
  geom_smooth(se=FALSE)
#ii)
ggplot(gapminder,aes(x=log10GdpPercap,y=lifeExp,color=year)) + geom_point() + 
  geom_smooth(aes(group=year), se=FALSE)

# ggplot scales
p2

# ggplot coodinate system
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp, color=continent)) +
  geom_point(alpha=0.5) + coord_trans(x="log10")

# ggplot faceting
p2 + facet_grid(continent ~ .)
