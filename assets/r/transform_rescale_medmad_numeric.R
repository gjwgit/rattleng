# Transform variables by rescaling. 

# The 'reshape' package provides the 'rescaler' function.

library(reshape, quietly=TRUE)

var <- SELECTED_VAR

newvar <- paste("RRC_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Rescale by subtracting median and dividing by median abs deviation.

ds[[newvar]] <-  rescaler(ds[[var]], "robust")
