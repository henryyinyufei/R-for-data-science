# Load packages and datasets
library(tidyverse)

# Example data
set.seed(42)
n <- 100
x1 <- rnorm(n); x2 <- rnorm(n)
y1 <- x1 + rnorm(n, sd=.5); y2 <- x1 + x2 + rnorm(n, sd=.5)
y3 <- x2 + rnorm(n, sd=.5); y4 <- rnorm(n, sd=.5)
rr <- list(fit1 = lm(y1 ~ x1 + x2),
           fit2 = lm(y2 ~ x1 + x2),
           fit3 = lm(y3 ~ x1 + x2),
           fit4 = lm(y4 ~ x1 + x2))
coef(rr$fit1)

################################################## Exercise 1 ###########################################################
# The elements of the list rr from last slide are lm objects. The function coef() is generic. 
# Assign class ¡°lm_vec¡± to rr and write a coef() method for objects of this class. 
# (Hint: Your function could include a for() loop like that below. 
# The output of coef() taking rr as input should be the same as the output from the for loop.)
for(i in seq_along(rr)) { # safer than 1:length(rr)
  print(coef(rr[[i]]))
}


class(rr) <- "lm_vec"
coef.lm_vec <- function(x) {
  for(i in seq_along(x)){print(coef(x[[i]]))}
}
coef(rr)

# Extracting the regression coefficient for x1
betahat <- vector("double", length(rr))
for(i in seq_along(rr)) {
  betahat[i] <- coef(rr[[i]])["x1"]
}
betahat

# Looping over elements of a set
fits <- paste0("fit",1:4)
for (ff in fits) {
  print(coef(rr[[ff]])["x1"])
}

# Avoid growing vectors incrementally
means <- seq.int(1000)
set.seed(123)
system.time({
  output <- double()
  for (i in seq_along(means)) {
    n <- sample(100, 1)
    output <- c(output, rnorm(n, means[[i]]))
  }
})

# Not growing vectors incrementally
system.time({
  out <- vector("list", length(means))
  for (i in seq_along(means)) {
    n <- sample(100, 1)
    out[[i]] <- rnorm(n, mean[[i]])
  }
  out <- unlist(out)
})

# bind_cols() and bind_rows()
#bind_cols(); recall that the length(means) = 1000
out <- vector("list", length(means))
n <- 100
for (i in seq_along(means)) {
  out[[i]] <- rnorm(n, means[[i]])
}
out <- bind_cols(out)
dim(out)
#bind_rows()
out <- vector("list", length(means))
for (i in seq_along(means)) {
  out[[i]] <- tibble(y = rnorm(n, means[[i]]), x = rnorm(n))
}
out <- bind_rows(out)
dim(out)

# The body of a loop can be a small part of the code
betahat <- vector("double", length(rr))
for (i in seq_along(rr)) {
  betahat[i] <- coef(rr[[i]])["x2"]
}
betahat

################################################## Exercise 2 ###########################################################
# Write a for() loop to find the mode() of each column in nycflights13::flights
flights <- nycflights13::flights
flights_mode <- vector("character", length(flights))
for (i in seq_along(flights)) {
  flights_mode[i] <- mode(flights[[i]])
}
flights_mode

# Using lapply()
b1fun <- function(fit) { coef(fit)["x1"] } # body
lapply(rr, b1fun) # or sapply(rr, b1fun) or unlist(lapply(rr, b1fun))
sapply(rr, b1fun)
unlist(lapply(rr, b1fun))

bfun <- function(fit,cc) { coef(fit)[cc] } # body
lapply(rr,bfun,"x1")

################################################## Exercise 3 ###########################################################
# Re-write your coef() method for objects of class lm_vec to use lapply().
class(rr) <- "lm_vec"
coef.lm_vec <- function(x) { 
  fun <- function(fit) { coef(fit) }
  return(lapply(rr, fun))
}
coef(rr)

# Iterating with the map() functions from purrr
library(purrr)
map_dbl(rr, b1fun) # or rr %>% map_dbl(b1fun)
map_dbl(rr, bfun, "x1") 

################################################## Exercise 4 ###########################################################
# Use map_chr() to return the mode() of each column of the nycflights13::flights tibble
map_chr(flights, mode)
# Use map() to return the summary() of each column of the nycflights13::flights tibble.
map(flights, summary)

# Pipes and map() functions
rr %>% 
  map(summary) %>% 
  map_dbl(function(ss) { ss$r.squared })
# map() functions have a short-cut for function definitions
rr %>% 
  map(summary) %>% 
  map_dbl(~. $r.squared) # or map_dbl("r.squared")

rr %>% 
  map(summary) %>% 
  map_dbl("r.squared")

map_dbl(map(rr,summary), "r.squared")
################################################## Exercise 5 ###########################################################
# Write a call to map_dbl() that does the same thing as map_dbl(rr,b1fun), 
# but define the function on the fly, as in the previous slide. 
# You can use multiple calls to map() functions.
map_dbl(rr, b1fun)
#
rr %>% 
  map(coef) %>% 
  map_dbl(function(x) { x["x1"] })

rr %>% 
  map(coef) %>% 
  map_dbl(~. ["x1"])

rr %>% 
  map(coef) %>% 
  map_dbl("x1")

# Detour: The apply family of functions in R
mat <- matrix(1:6, ncol = 2, nrow = 3)
mat
apply(mat, 1, sum) # row-wise sums; rowSums() is faster
rowSums(mat)
apply(mat, 2, sum) # column-wise; colSums() is faster
colSums(mat)

# Detour, cont.
lapply(rr, coef) 
sapply(rr, coef) # sapply() takes the output of lapply() and simplifies to a vector or matrix.

















