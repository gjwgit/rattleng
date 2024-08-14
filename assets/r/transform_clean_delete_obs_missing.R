# Removes rows with any NA values.

ds <- ds[complete.cases(ds),]

glimpse(ds)
summary(ds)
