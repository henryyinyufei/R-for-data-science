library(tidyverse)

# Textbook Example: General Social Survey
gss_cat

# When factors are stored in a tibble, you can¡¯t see their levels so easily. One way to see them is with count():
gss_cat %>% 
  count(race)
# Or with a bar chart:
ggplot(gss_cat, aes(race)) + geom_bar()
# By default, ggplot2 will drop levels that don¡¯t have any values. You can force them to display with:
ggplot(gss_cat, aes(race)) + geom_bar() + scale_x_discrete(drop = FALSE)


################################################## Modifying factor order ###############################################
#########################################################################################################################
relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

# reordering the levels of relig using fct_reorder()
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

#  recommend moving them out of aes() and into a separate mutate() step.
relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

# create a similar plot looking at how average age varies across reported income level
rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()

# it does make sense to pull ¡°Not applicable¡± to the front with the other special levels. You can use fct_relevel().
ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

# fct_reorder2() reorders the factor by the y values associated with the largest x values.
by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

# you can use fct_infreq() to order levels in increasing frequency
# fct_rev() reverse
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

################################################## Modifying factor levels ##############################################
#########################################################################################################################
gss_cat %>% count(partyid)

# The levels are terse and inconsistent. Let¡¯s tweak them to be longer and use a parallel construction.
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

# To combine groups, you can assign multiple old levels to the same new level
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)

# If you want to collapse a lot of levels, fct_collapse() is a useful variant of fct_recode(). 
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

# Sometimes you just want to lump together all the small groups to make a plot or table simpler. 
#That¡¯s the job of fct_lump()
gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

# we can use the n parameter to specify how many groups (excluding other) we want to keep
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)






