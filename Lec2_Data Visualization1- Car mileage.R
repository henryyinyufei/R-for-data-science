# Example: Car mileage
library(tidyverse)
data(mpg)
head(mpg)

# to view the dataset
view(mpg)
# details on the variables.
?mpg

# First ggplot
# plot hwy versus displ as follows:
ggplot(data = mpg) + geom_point(mapping = aes(x=displ,y=hwy))

# we colored the points,points to be blue
ggplot(data = mpg) + geom_point(mapping = aes(x=displ,y=hwy),color="blue")

# Second ggplot
# plot hwy versus displ with colors to represent different kinds of cars:
ggplot(data = mpg) + geom_point(mapping = aes(x=displ, y=hwy, color=class))

################################################## Exercise #############################################################
# Redo the above scatterplot but using the aesthetic shape=class to plot different shapes for different kinds of cars
ggplot(data = mpg) + geom_point(mapping = aes(x=displ, y=hwy, shape=class))

# Geometric objects
# scatterplot smooths for each class of car.
ggplot(data = mpg) + geom_smooth(mapping = aes(x=displ, y=hwy, color=class))

# Multiple geoms
# In the following we specify a default aesthetic mapping that is
#used by both the points and smooth.
ggplot(data = mpg, mapping = aes(x=displ, y=hwy, color=class)) +
  geom_point() +
  geom_smooth()

# Facets
# We can split into multiple scatterplots or ¡°facets¡±.
ggplot(data = mpg, mapping = aes(x=displ, y=hwy, color=class)) +
  geom_point() + geom_smooth() +
  facet_wrap(~ class, nrow = 2)
# Repeat the above example, but omit the nrow = 2 argument to facet_wrap().
ggplot(data = mpg, mapping = aes(x=displ, y=hwy, color=class)) +
  geom_point() + geom_smooth() +
  facet_wrap(~ class)

# Faceting on two variables.
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color=class)) +
  facet_grid(drv ~ cyl)
  