# Bin the SELECTED_VAR into NUMBER bins using quantiles.

ds[["BQ_SELECTED_VAR_NUMBER"]] <- binning(ds[["SELECTED_VAR"]], NUMBER, method="quantile", ordered=FALSE)
