# The 'reshape' package provides the 'rescaler' function.

library(reshape, quietly=TRUE)

# Rescale MinTemp.

crs$dataset[["RRK_SELECTED_VAR"]] <- crs$dataset[["SELECTED_VAR"]]

# Convert values to ranks.

if (building)
{
  crs$dataset[["RRK_SELECTED_VAR"]] <-  rescaler(crs$dataset[["SELECTED_VAR"]], "rank")
}
