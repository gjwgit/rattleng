# The 'reshape' package provides the 'rescaler' function.


# Rescale SELECTED.

ds[["RRK_SELECTED_VAR"]] <- ds[["SELECTED_VAR"]]

# Convert values to ranks.

ds[["RRK_SELECTED_VAR"]] <-  reshape::rescaler(ds[["SELECTED_VAR"]], "rank")

glimpse(ds)
summary(ds)

