library(ggplot2)
data(diamonds)
library(dplyr)
library(gapminder)
data(gapminder)

# mutate() function from dplyr package.
gapminder <- mutate(gapminder,
                    log10Pop = log10(pop),
                    log10GdpPercap = log10(gdpPercap))

# diamond dataset
p <- ggplot(diamonds,aes(x=carat,y=price,colour=cut)) +
  geom_point()
names(p)
p

# data
# change the data of a plot object with %+%
set.seed(123)
subdiamonds <- sample_n(diamonds,size=100)
p <- p %+% subdiamonds
p

# Can specify data for a layer to use
p + geom_smooth(data=diamonds, method="lm")

# Aesthetic mappings
# Warning: Specifying a mapping twice can have unexpected consequences!
p + geom_point(aes(color=clarity))

################################################## Exercise ############################################################
# Write R code to produce a scatterplot of price versus carat, with
#different colors for values of clarity, using the subdiamonds dataset.
set.seed(123)
subdiamonds <- sample_n(diamonds,size=100)
ggplot(subdiamonds, aes(x=carat,y=price,color=clarity)) +
  geom_point()

# Setting vs mapping
ggplot(subdiamonds, aes(x=carat,y=price)) + geom_point(color="darkblue")
################################################## Exercise ############################################################
# Redo the above plot with the mapping color=¡°darkblue¡± for the
#geom_point() rather than the parameter color=¡°darkblue¡±.
# see a bizarre plot with confusing legend.
ggplot(subdiamonds, aes(x=carat,y=price)) + geom_point(aes(color="darkblue"))

# grouping
# gapminder data again: Grouping to plot time series
# group by observational unit.(country)
ggplot(gapminder,aes(x=year,y=lifeExp,group=country)) +
  geom_line(alpha=0.5)

# Different groups on different layers
ggplot(gapminder,aes(x=year,y=lifeExp,color=continent)) +
  geom_line(aes(group=country),alpha=0.2) +
  geom_smooth(aes(group=continent),se=FALSE)

################################################## Exercise ############################################################
# Redo the above, but remove the mapping in geom_line() and specify
#group=country in the default mapping. What grouping variable is used by
#geom_line()? What grouping variable is used by geom_smooth()?
ggplot(gapminder,aes(x=year,y=lifeExp,color=continent,group=country)) +
  geom_line(alpha=0.2) +
  geom_smooth(aes(group=continent),se=FALSE)

# Using interaction() to specify groups
ggplot(gapminder,aes(x=year,y=lifeExp,
                     group=interaction(year,continent),color=continent)) +
  geom_boxplot()
# overriding group on a layer 
ggplot(gapminder,aes(x=year,y=lifeExp,group=interaction(year,continent),
                     color=continent)) + geom_boxplot() +
  geom_smooth(aes(group=continent),se=FALSE)

# Stats
# stats creat new variables, enclose drived variable name with .. to use
p <- ggplot(gapminder,aes(x=lifeExp)) +
  geom_histogram(aes(y=..density..))
p

# positioin adjustment 
# histograms ("stack"ed by default)
gdat <- filter(gapminder,year==1952)
ggplot(gdat,aes(x=lifeExp,color=continent)) + geom_histogram()

# Displaying distributions
# Histograms with faceting
gdat <- filter(gdat,continent!="Oceania")
h <- ggplot(gdat,aes(x=lifeExp))
h + geom_histogram(aes(y=..density..),binwidth=5) + facet_grid(continent~.)

# Histograms superposed
h + geom_freqpoly(aes(y=..density..,color=continent),binwidth=5)

# Density estimation
h + geom_density(aes(color=continent))

# Violin plots (dodge density estimation)
h + geom_violin(aes(x=continent,y=lifeExp))

# Adding measures of uncertainty 
gfit <- lm(lifeExp ~ continent,data=gdat)
newdat <- data.frame(continent=c("Africa","Americas","Asia","Europe"))
mm <- data.frame(newdat,predict(gfit,newdata=newdat,interval="confidence"))
ggplot(mm,aes(x=continent,y=fit)) +
  geom_point() + geom_errorbar(aes(ymin=lwr,ymax=upr))

# Measures of uncertainty with stat summaries
library(Hmisc) # Need to have Hmisc package installed
ggplot(gdat,aes(x=continent,y=lifeExp)) +
  geom_violin() + # superpose over violin plot
  stat_summary(fun.data="mean_cl_normal",color="red")

# Annotating a plot
# Many annotations
# to add many at a time, create a data frame
gm07 <- filter(gapminder,year==2007)
topOilbyGDP <- c("Kuwait","Guinea","Norway","Saudi Arabia")
gdpOil <- filter(gm07,country %in% topOilbyGDP)
ggplot(gm07,aes(x=gdpPercap,y=lifeExp)) + geom_point() +
  geom_text(data=gdpOil,aes(label=country))
