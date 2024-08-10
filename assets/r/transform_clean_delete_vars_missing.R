# delete columns with any missing values
ds <- ds[ , !(names(ds) %in% MISSING_VARS)]
