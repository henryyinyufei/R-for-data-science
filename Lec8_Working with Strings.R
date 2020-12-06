# Load packages and datasets
library(tidyverse)
library(stringr) # is part of tidyverse

# Counting the number of characters with str_length
mystrings <- c("one fish", "two fish",
               "red fish", "blue fish")
str_length(mystrings)

# Combining Strings with str_c()
str_c(mystrings[1], mystrings[2])
str_c(mystrings[1], mystrings[2], sep=", ")
str_c(mystrings[1], NA, sep=", ")
str_c(mystrings[1], str_replace_na(NA), sep=", ")
str_c(mystrings, collapse = ", ")

# Subsetting Strings with str_sub()
str_sub(mystrings, 1, 3)
str_sub(mystrings, -4, -1)
str_sub(mystrings, 1, 10000)
str_sub(mystrings, 9, 10000)

################################################## Exercise ############################################################
# For demog as defined in the following code chunk
demog <- c("new_sp_f014",
           "new_sp_m1524",
           "new_sp_mu")

# 1. using one line of code, extract the substring that represents the gender and age category 
#(u stands for unknown) from each of the three components;
str_sub(demog, 8, 10000)

# 2. extract the last four characters of each of the three components;
str_sub(demog, -4, -1)

# 3. Combine the three components into one string, separated by a plus-sign.
str_c(demog, collapse = " + ")

# Detecting substrings with str_detect()
pattern <- "red"
str_detect(mystrings, pattern)

mystrings[str_detect(mystrings, pattern)]

pattern <- "fish"
str_detect(mystrings, pattern)

# Finding substring starting position
Seuss <- str_c(mystrings, collapse = ", ")
str_locate(Seuss, pattern)
str_locate_all(Seuss, pattern)
str_locate_all(mystrings, pattern)

# Replacing (substituting) substrings
str_replace(Seuss, "fish", "bird") # replace first occurance
str_replace_all(Seuss, "fish", "bird") # replace all
str_replace_all(Seuss, c("one" = "1", "two" = "2")) # multiple replacements

# Splitting Strings
mystrings <- c("20.50", "33.33")
str_split(mystrings, pattern = ".") 
str_split(mystrings, pattern = fixed("."))

# Working with string patterns: regular expressions
# A simple pattern with .
pattern <- "p.n"
mystrings <- c("pineapple", "apple", "pen")
str_detect(mystrings, pattern)

# Matching Special Characters
pattern2 <- "3.40"
mystrings2 <- c("33.40", "3340")
str_detect(mystrings2, pattern2)

pattern2 <- "3\\.40"
str_detect(mystrings2, pattern2)

# Splitting, Locating and Extracting with Patterns
mystrings
pattern
str_split(mystrings, pattern)
str_locate(mystrings, pattern)
str_extract(mystrings, pattern)
str_match(mystrings, pattern)

# Replacing patterns
str_replace(mystrings, pattern, "PPAP")
str_replace(mystrings, pattern, "p.n")

################################################## Exercise ############################################################
# Replace the decimals with commas in the following strings.
exstring <- c("$55.30","$22.43")
str_replace_all(exstring, pattern = fixed("."), ",")
str_replace_all(exstring, "\\.", ",")

# Adding * and + quantifiers to .
mystrings <- c("fun", "for fun", "fn")
pattern1 <- "f.*n" ; pattern2 <- "f.+n"
str_extract(mystrings, pattern1)
str_extract(mystrings, pattern2)

# ¡°Greedy¡± matching with *
mystrings <- c("fun","fun, fun, fun","fn")
pattern1 <- "f.*n"
str_extract(mystrings, pattern1)

# Numerical quantifiers
str_extract(mystrings, "f.{6}n")
str_extract(mystrings, "f.{1,13}n")

# Anchors
mystrings <- c("pineapple","apple","pen")
str_extract(mystrings, "^p")
str_extract(mystrings, "e$")

################################################## Exercise ############################################################
# Create a regular expression that matches words that are exactly three letters long.
myregexp1 <- "^.{3}$"
"^...$"
sum(str_detect(stringr::words,myregexp))

# Other characters to match
pattern4 <- "f[aeiou]*n"
mystrings <- c("fan", "fin", "fun", "fan, fin, fun", "friend", "faint")
str_extract(mystrings, pattern4)
str_extract_all(mystrings, pattern4)

################################################## Exercise ############################################################
# Create a regular expression that matches words that end in ed but not eed.
myregexp2 <- "[^e]ed$"
sum(str_detect(stringr::words,myregexp2))
str_subset(c("ed", stringr::words), "(^|[^e])ed$")

# Alternatives
str_replace_all(Seuss, "red|blue", "color")
str_replace_all("Is it grey or gray?", "gr(e|a)y", "white")

# Converting Case
str_to_upper(Seuss)
# str_to_lower()




