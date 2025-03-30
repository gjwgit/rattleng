# Removes rows with any NA values for the target variable.

ds %<>% filter(!is.na(!!sym(target)))

glimpse(ds)
summary(ds)
