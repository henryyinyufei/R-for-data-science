# Load packages and datasets
library(tidyverse)
library(forcats)
library(lubridate)
library(nycflights13)

# Creating a Factor
x1 <- c("dog", "cat", "mouse"); x2 <- factor(x1); x2
x1 <- c(3, 4, 1); x2 <- factor(x1); x2
x1 <- c(TRUE, FALSE, TRUE); x2 <- factor(x1); x2

x1 <- c("dog", "cat", "mouse"); x2 <- factor(x1)
str(x2)
x2 <- factor(x1, levels = c("mouse", "cat", "dog"))
str(x2)
x2 <- factor(x1, levels = unique(x1))
str(x2)

# More or Fewer levels than Values
x1
ll <- c("cat", "dog", "horse", "mouse")
factor(x1, levels = ll) # More
ll <- ll[1:2]
factor(x1, levels = ll) # Fewer

# Accessing the Levels
# shy away from using levels()
levels(x2)
levels(x2) <- c("Mouse", "Cat", "Dog")
x2

# Example Data: Canadian Communities Health Survey
# Health Utilities Index (HUI) Variables
hui <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/Lec09HUI.csv.gz", col_types = cols(
    GEO_PRV = col_factor(),     # province
    GEOGCMA2 = col_factor(),    # urban/rural
    DHHGAGE = col_factor(),     # age categories
    DHH_SEX = col_factor(),     # sex
    HUIDCOG = col_factor(),     # cognitive score
    HUIGDEX = col_factor(),     # dexterity score
    HUIDEMO = col_factor(),     # emotional 
    HUIGHER = col_factor(),     # hearing 
    HUIDHSI = col_double(),     # index variable 
    HUIGMOB = col_factor(),     # mobility
    HUIGSPE = col_factor(),     # speech trouble 
    HUIGVIS = col_factor(),     # vision
    WTS_M = col_double()        # sampling weights
))

# HUIDHSI
# We will look at how HUIDHSI varies by other factors, such as province
hui %>% group_by(GEO_PRV) %>%
  summarize(mean = weighted.mean(HUIDHSI, WTS_M, na.rm = TRUE)) %>%
  ggplot(aes(x = mean, y = GEO_PRV)) + geom_point()

# Reordering Factor Levels
# Use fct_reorder() to reorder levels by a second variable
hui %>% group_by(GEO_PRV) %>%
  summarize(mean = weighted.mean(HUIDHSI, WTS_M, na.rm = TRUE)) %>%
  ggplot(aes(x = mean, y = fct_reorder(GEO_PRV, mean))) + geom_point()

# Manual Re-order
# fct_relevel() lets you move levels to the front of the ordering, to partially or completely re-order a factor¡¯s levels
WtoE <- c("BC","AB","SASK","MB","ONT","QUE",
          "NB","PEI","NS","NFLD & LAB.")
hui %>% group_by(GEO_PRV) %>%
  summarize(mean = weighted.mean(HUIDHSI, WTS_M, na.rm = TRUE)) %>%
  ggplot(aes(x = fct_relevel(GEO_PRV, WtoE), y = mean)) + geom_point()

# Ordering Levels by Frequency
ggplot(hui, aes(x = fct_infreq(GEO_PRV))) + geom_bar()

# Modifying Factor Levels
# For labelling, change factor levels to complete province names.
hui <- hui %>%
  mutate(GEO_PRV = fct_recode(GEO_PRV,
                              "British Columbia" = "BC",
                              "Alberta" = "AB",
                              "Saskatchewan" = "SASK",
                              "Manitoba" = "MB",
                              "Ontario" = "ONT",
                              "Qu¨¦bec" = "QUE",
                              "New Brunswick" = "NB",
                              "Prince Edward Island" = "PEI",
                              "Nova Scotia" = "NS",
                              "Newfoundlad & Labrador" = "NFLD & LAB."))
hui %>% group_by(GEO_PRV) %>%
  summarize(mean = weighted.mean(HUIDHSI,WTS_M,na.rm=TRUE)) %>%
  ggplot(aes(x=mean,y=fct_reorder(GEO_PRV,mean))) + geom_point()                             

# We can also use fct_recode() to combine levels.
hui %>%
  mutate(GEO_PRV = fct_recode(GEO_PRV,
                              "Maritimes" = "New Brunswick",
                              "Maritimes" = "Prince Edward Island",
                              "Maritimes" = "Nova Scotia",
                              "Maritimes" = "Newfoundlad & Labrador")) %>%
  group_by(GEO_PRV) %>%
  summarize(mean = weighted.mean(HUIDHSI,WTS_M,na.rm=TRUE)) %>%
  ggplot(aes(x=mean,y=fct_reorder(GEO_PRV,mean))) + geom_point()

# Grouping, or Lumping Infrequent Levels
hui %>% mutate(GEO_PRV = fct_lump(GEO_PRV, w = WTS_M)) %>%
  group_by(GEO_PRV) %>%
  summarize(mean = weighted.mean(HUIDHSI, WTS_M, na.rm = TRUE)) %>%
  ggplot(aes(x = mean, y = fct_reorder(GEO_PRV, mean))) + geom_point()

################################################## Exercise 1 ##########################################################
# The levels of HUIDCOG are COG. ATT. LEVE 1 through COG. ATT. LEVE 6. 
# Recode these in terms of memory and thinking abilities, as follows:
# 1. good memory, clear thinking
# 2. good memory, some difficulty thinking
# 3. somewhat forgetful, clear thinking
# 4. somewhat forgetful, some difficulty thinking
# 5. very forgetful, great difficulty thinking
# 6. unable to remember, unable to think
# Save your recoded variable for use in Exercises 2 to 4.
huiw <- hui %>% filter(!is.na(HUIDCOG)) %>%
  mutate(HUIDCOG = fct_recode(HUIDCOG,
                              "good memory, clear thinking" = "COG. ATT. LEVE 1",
                              "good memory, some difficulty thinking" = "COG. ATT. LEVE 2",
                              "somewhat forgetful, clear thinking" = "COG. ATT. LEVE 3",
                              "somewhat forgetful, some difficulty thinking" = "COG. ATT. LEVE 4",
                              "very forgetful, great difficulty thinking" = "COG. ATT. LEVE 5",
                              "unable to remember, unable to think" = "COG. ATT. LEVE 6"))

################################################## Exercise 2 ##########################################################
# For each level of HUIDCOG calculate wtd.n = sum(WTS_M). Plot the levels of HUIDCOG versus the log-base10
#of wtd.n with geom_point().
huiw %>% group_by(HUIDCOG) %>%
  summarize(wtd.n = sum(WTS_M)) %>%
  ggplot(aes(x = log10(wtd.n), y = HUIDCOG)) + geom_point()

################################################## Exercise 3 ##########################################################
#Repeat exercise 2, but with the levels of HUIDCOG ordered by wtd.n.
huiw %>% group_by(HUIDCOG) %>%
  summarize(wtd.n = sum(WTS_M)) %>%
  ggplot(aes(x = log10(wtd.n), y = fct_reorder(HUIDCOG, wtd.n))) + geom_point()

################################################## Exercise 4 ##########################################################
#Repeat Exercise 3, but with the levels of HUIDCOG recoded according to memory as 
#¡°good memory¡±, ¡°somewhat forgetful¡±, ¡°very forgetful¡± or ¡°unable to remember¡±.
huiw %>% 
  mutate(HUIDCOG = fct_recode(HUIDCOG,
                              "good memory" = "good memory, clear thinking",
                              "good memory" = "good memory, some difficulty thinking",
                              "somewhat forgetful" = "somewhat forgetful, clear thinking",
                              "somewhat forgetful" = "somewhat forgetful, some difficulty thinking",
                              "very forgetful" = "very forgetful, great difficulty thinking",
                              "unable to remember" = "unable to remember, unable to think")) %>%
  group_by(HUIDCOG) %>%
  summarize(wtd.n = sum(WTS_M)) %>%
  ggplot(aes(x = log10(wtd.n), y = fct_reorder(HUIDCOG, wtd.n))) + geom_point()
# OR (using fct_collapse())
huiw %>% 
  mutate(HUIDCOG = fct_collapse(HUIDCOG,
    `good memory` = c("good memory, clear thinking", "good memory, some difficulty thinking"),
    `somewhat forgetful` = c("somewhat forgetful, clear thinking", "somewhat forgetful, some difficulty thinking"),
    `very forgetful` = c("very forgetful, great difficulty thinking"),
    `unable to remember` = c("unable to remember, unable to think"))) %>%
  group_by(HUIDCOG) %>%
  summarize(wtd.n = sum(WTS_M)) %>%
  ggplot(aes(x = log10(wtd.n), y = fct_reorder(HUIDCOG, wtd.n))) + geom_point()
  
    

# Dates and Times From Strings
ymd("19-09-01"); ymd("20190901"); ymd("2019September01")
mdy("09-01-2019"); mdy("09012019"); mdy("Sep 1, 2019")
ymd_hm("19-09-01 2:00")

# Time Zones
Sys.timezone()

# Example data
yvr <- read_csv("D:/Simon Fraser University/2020 fall/STAT 260/examples/Lec09weatherYVROct2019.csv") %>%
  select("Date/Time", Year, Month, Day, Time, "Temp (C)")
yvr

# Coerce Date/Time
yvr <- yvr %>% mutate(`Date/Time` =  ymd_hm(`Date/Time`, tz = "America/Vancouver"))
yvr

# Time Series Plots with Date-times
ggplot(yvr, aes(x = `Date/Time`, y = `Temp (C)`)) + geom_line()

# Date-time from Components
yvrdt <- yvr %>%
  mutate(datetime =
           make_datetime(Year, Month, Day, hour(Time), minute(Time),
           tz = "America/Vancouver")) %>%
  select(`Date/Time`, datetime)
yvrdt

# Durations
(ymd_hms("20191029 01:01:00") - ymd_hms("20191028 01:00:00"))
(ymd_hms("20191028 01:01:00") - ymd_hms("20191028 01:00:00"))
as.duration(ymd_hms("20191028 01:01:00") - ymd_hms("20191028 01:00:00")) # Durations are always in seconds

yvrdt %>% 
  mutate(diff = datetime - mean(datetime),
         diffsec = as.duration(datetime - mean(datetime))) %>%
  summarize(sd = sd(diff), sd2 = sd(diffsec))

yvrdt$datetime - mean(yvrdt$datetime)

################################################## Exercise 5 ##########################################################
# Verify that the datetime object created on about slide 29 is equal to 
#the Date/Time object created earlier with ymd_hm().
# Use the sd() function to calculate the SD of the datetime object. What are the units?
yvrdt$datetime - yvrdt$`Date/Time`
as.duration(yvrdt$datetime - yvrdt$`Date/Time`)
sd(yvrdt$datetime)  # second 

# Solution
yvrdt %>% summarize(any(`Date/Time` != datetime))
yvrdt %>% summarize(sd = sd(datetime))





