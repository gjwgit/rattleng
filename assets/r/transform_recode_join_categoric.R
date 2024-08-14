# Remap variables. 

# Turn two factors into one factor.

ds[, "TJN_SELECTED_VAR_SELECTED_2_VAR"] <- interaction(paste(ds[["SELECTED_VAR"]], "_",ds[["SELECTED_2_VAR"]], sep=""))
ds[["TJN_SELECTED_VAR_SELECTED_2_VAR"]][grepl("^NA_|_NA$", ds[["TJN_SELECTED_VAR_SELECTED_2_VAR"]])] <- NA
ds[["TJN_SELECTED_VAR_SELECTED_2_VAR"]] <- as.factor(as.character(ds[["TJN_SELECTED_VAR_SELECTED_2_VAR"]]))

