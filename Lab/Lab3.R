library(tidyverse)
hiv <- read.csv("D:/Simon Fraser University/2020 fall/STAT 261/lab3/HIVprev.csv",stringsAsFactors = FALSE)
hiv <- select(hiv,Country, year, prevalence)

head(hiv)
tail(hiv)
summary(hiv)

#Exercises:
# 1. Plot the time series of HIV prevalence by year for each country using geom_line(). Color the lines
#according to HIV prevalence. Add the title ¡°Estimated HIV Prevalence 1990-2000¡± and change the
#y-axis label to ¡°estimated prevalence¡±.
ggplot(hiv,aes(x=year,y=prevalence,gourp=Country)) + 
  geom_line(aes(color=prevalence)) +
  labs(y="estimated prevalence",title="Estimated HIV Prevalence 1990-2000")

# 2.If you look closely at the previous plot you will notice that geom_line() draws ¡°jagged¡± lines. This is
#because it draws a straight line between data points, as opposed to fitting a smooth curve. (To see this
#you can add a layer to the plot to include the points.) For this exercise, make a new time series plot.
#Instead of using geom_line(),fit and draw smoothers to represent the time series for each country.
#That is, plot smooth time series of HIV prevalence by year for each country 
#(hint: use geom_smooth()).For this plot, make the drawn curves colored blue.(This plot should not include points, 
#confidence bands, or any other superfluous details.)
ggplot(hiv,aes(x=year,y=prevalence,gourp=Country)) + 
  geom_smooth(color="blue",se=FALSE) +
  labs(y="estimated prevalence",title="Estimated HIV Prevalence 1990-2000")

# 3. In the following code chunk we create a new dataset comprised of countries that had HIV prevalence
#greater than 10% in one or more of the years monitored (we will learn about this kind of ¡°data wrangling¡±
#in future lectures of STAT 260).
cc <- c("Botswana","Central African Republic","Congo","Kenya","Lesotho","Malawi",
        "Namibia","South Africa","Swaziland","Uganda","Zambia","Zimbabwe")
hihiv <- filter(hiv,Country %in% cc)

# Redo the time series plot from Exercise 1, with the following modifications. Color the time series for all but
#the countries in the hihiv data frame (i.e., those with high HIV prevalence) grey and with alpha=0.3. For
#the high-HIV-prevalence countries, color them red, also using alpha=0.3. Next, add two smoothers: (i) for
#all the data, i.e. all the countries in the hiv data frame, colored black, and (ii) for the countries with a high
#prevalence of HIV, i.e. those in the hihiv data frame, colored red. Your final plot should look like this:
ggplot(hiv,aes(x=year,y=prevalence)) + 
  geom_line(aes(group=Country),color="grey",alpha=0.3) +
  geom_line(data=hihiv,aes(group=Country),color="red",alpha=0.3) +
  geom_smooth(color="black") +
  geom_smooth(data= hihiv,color="red") +
  labs(y="estimated prevalence",title="Estimated HIV Prevalence 1990-2000")


# Quiz 
ggplot(hiv,aes(x=year,y=prevalence,gourp=Country)) + 
  geom_smooth(color="orange",se=FALSE) +
  labs(y="estimated prevalence(%)")
  
ggplot(hihiv,aes(x=year,y=prevalence)) +
  geom_line(aes(group=Country),color="blue",alpha=0.3) +
  geom_smooth(color="orange")





