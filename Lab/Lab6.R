library(tidyverse)
hiv <- read_csv("D:/Simon Fraser University/2020 fall/STAT 261/lab6/HIVprevRaw.csv")
hivcopy <- hiv
# 1. The first column of the data frame is the country, but it has been namedEstimated HIV Prevalence%
#- (Ages 15-49). Use the rename() function to rename this column Country. (Hint: The current                                                                         
#variable name contains special characters and will need to be enclosed in quotes.)
names(hiv)
hiv <- rename(hiv,Country=`Estimated HIV Prevalence% - (Ages 15-49)`)

# 2. The data from 1979 to 1989 is very sparse. Remove these columns from the data frame.
hiv <- select(hiv,-(`1979`:`1989`))

# 3. Gather the yearly prevalence estimates into key, value pairs with year as the key and prevalence as
#the value. When you gather, remove explicity missing values. After gathering, sort on ¡°Country¡±.
hiv <- gather(hiv,`1990`:`2011`,key=year,value=prevalence,na.rm=TRUE) %>%
  arrange(Country)

# pipe
hivcopy <- rename(hivcopy ,Country=`Estimated HIV Prevalence% - (Ages 15-49)`) %>%
  select(-(`1979`:`1989`)) %>%
  gather(`1990`:`2011`,key=year,value=prevalence,na.rm=TRUE) %>%
  arrange(Country)
  