# Transform variables by rescaling. 

# The 'reshape' package provides the 'rescaler' function.

library(reshape, quietly=TRUE)

# Rescale SELECTED_VAR.

var <- SELECTED_VAR

newvar <- paste("R01_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

ds[[newvar]] <-  rescaler(ds[[var]], "range")
