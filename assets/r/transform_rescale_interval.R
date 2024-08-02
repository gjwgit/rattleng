# The 'reshape' package provides the 'rescaler' function.

# library(reshape, quietly=TRUE)

# Rescale SELECTED_VAR.

ds[["RIN_SELECTED_VAR_INTERVALS"]] <- ds[["SELECTED_VAR"]]

# Rescale to 0 to INTERVALS within each group.

ds[["RIN_SELECTED_VAR_INTERVAL"]] <-
    reshape::rescale.by.group(ds[["SELECTED_VAR"]], type="irank", itop=INTERVALS)
