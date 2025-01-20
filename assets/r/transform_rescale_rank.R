# Use base::rank. Works with factors, presumably using their integer
# value.

ds %>% mutate(<RRK_<SELECTED_VAR> = rank(<SELECTED_VAR>))

glimpse(ds)
summary(ds)
