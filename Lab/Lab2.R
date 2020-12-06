library(tidyverse)

hiv <- read.csv("D:/Simon Fraser University/2020 fall/STAT 261/lab2/HIVprev.csv",stringsAsFactors = FALSE)
hiv <- select(hiv, Country, year, prevalence)

head(hiv)
tail(hiv)
summary(hiv)

#Exercises:
# 1. Plot time series of HIV prevalence by year for each country.
ggplot(hiv,aes(x=year,y=prevalence,gourp=Country)) + geom_line()

# 2. Redo the above plot but experiment with different alpha values. What problem does setting a small
#alpha overcome? What feature of the graph is hidden when we do not set alpha?
ggplot(hiv,aes(x=year,y=prevalence,group=Country)) + geom_line(alpha=.1)
# Due to many of the time series overlapping, we cannot observe that most coutries have an HIV prevalence of
#close to zero (i.e., there is overplotting). A small alpha value overcomes the overplotting and reveals the low
#HIV prevalence of most countries.

# 3. In the following code chunk we create a new dataset comprised of countries that had HIV prevalence
#greater than 10% in one or more of the years monitored (we will learn about this kind of ¡°data wrangling¡±
#in future lectures of STAT 260).
cc <- c("Botswana","Central African Republic","Congo","Kenya","Lesotho","Malawi",
        "Nambia","South Africa","Swaziland","Uganda","Zambia","Zimbabwe")
hihiv <- filter(hiv,Country %in% cc)
# Add red lines for the above countries to your time series plot.
ggplot(hiv,mapping = aes(x=year, y=prevalence,group=Country)) + geom_line(alpha=0.1) +
  geom_line(data=hihiv,color="red")

            