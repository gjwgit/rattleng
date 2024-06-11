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

# The 'basicStats' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Generate a description of the numeric data.

lapply(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)][,c(1:5, 7, 10:19, 21)], basicStats)

# The 'kurtosis' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Summarise the kurtosis of the numeric data.

kurtosis(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)][,c(1:5, 7, 10:19, 21)], na.rm=TRUE)

# The 'skewness' package provides the 'fBasics' function.

library(fBasics, quietly=TRUE)

# Summarise the skewness of the numeric data.

skewness(crs$dataset[crs$train, c(crs$input, crs$risk, crs$target)][,c(1:4, 7:116)], na.rm=TRUE)

# The 'mice' package provides the 'md.pattern' function.

library(mice, quietly=TRUE)

# Generate a summary of the missing values in the dataset.

md.pattern(crs$dataset[,c(crs$input, crs$target)])

# The 'CrossTable' package provides the 'descr' function.

library(descr, quietly=TRUE)

# Generate cross tabulations for categoric data.

for (i in c(8, 10:11, 22)) 
{ 
  cat(sprintf('CrossTab of %s by target variable %s\n\n', names(crs$dataset)[i], crs$target)) 
  print(CrossTable(crs$dataset[[i]], crs$dataset[[crs$target]], expected=TRUE, format='SAS')) 
  cat(paste(rep('=', 70), collapse=''), '

') 
}
