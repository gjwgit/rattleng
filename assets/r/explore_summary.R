UNDER DEVELOPMENT - THIS INCLUDES

summary
describe
skewness
missing

#=======================================================================
# Rattle timestamp: 2023-11-05 19:14:09.550017 x86_64-pc-linux-gnu 

# The 'Hmisc' package provides the 'contents' function.

library(Hmisc, quietly=TRUE)

# Obtain a summary of the dataset.

contents(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)])
summary(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)])

# The 'Hmisc' package provides the 'describe' function.

library(Hmisc, quietly=TRUE)

# Generate a description of the dataset.

describe(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)])

# The 'skewness' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Summarise the skewness of the numeric data.

skewness(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)][,c(1:4, 7:116)], na.rm=TRUE)

# The 'mice' package provides the 'md.pattern' function.

library(mice, quietly=TRUE)

# Generate a summary of the missing values in the dataset.

md.pattern(crs$dataset[,c(crs$input, crs$target)])
