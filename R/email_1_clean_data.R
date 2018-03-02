library(tidyverse)
library(googlesheets)
library(janitor)
library(fuzzywuzzyR)

# TODO

# 1. Join purchases with info about bulk items

order_data <- gs_title("purchases_feb22") %>% # who ordered what
  gs_read(ws = 1) %>%
  clean_names() # each observation is a purchase of one particular item. i.e. 
                # if you buy 6 items but 2 of them are egg cartons, you'll be in the data 5 times.

item_data <- gs_title("macshare_items") %>% # what was available
  gs_read(ws = 1) %>%
  clean_names() # each observation is an item available for purchase from MacShare. Includes price and bulk info

# need to clean product names 

names_items <- (item_data$name) 
names_orders <- (order_data$product_name)


close_match_vec <- function(word){
  matches <- c()
  x <- GetCloseMatches(string = word, sequence_strings = names_orders, n = 1L, cutoff = 0.6)
  return(x)
}

match_test <- lapply(names_items, close_match_vec)

test_tibble <- tibble(match = match_test,
            orig = names_items)


