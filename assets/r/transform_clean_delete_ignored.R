# Remove variables listed in the ignore list.

ds <- ds[ , !(names(ds) %in% <IGNORE_VARS>)]

glimpse(ds)
summary(ds)
