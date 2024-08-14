# Bin the SELECTED_VAR into NUMBER bins using kmeans.

ds[["BK_SELECTED_VAR_NUMBER"]] <- binning(ds[["SELECTED_VAR"]], NUMBER, method="kmeans", ordered=FALSE)
