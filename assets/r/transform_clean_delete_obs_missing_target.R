# Removes rows with the target variable having NA values.

ds %<>% filter(!is.na(!!sym(target)))

glimpse(ds)
summary(ds)
