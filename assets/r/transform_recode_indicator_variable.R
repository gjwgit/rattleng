# Remap variables. 

# Turn a factor into indicator variables.

ds[, make.names(paste("TIN_SELECTED_VAR", levels(ds[["SELECTED_VAR"]]), sep=""))] <- diag(nlevels(ds[["SELECTED_VAR"]]))[ds[["SELECTED_VAR"]],]
