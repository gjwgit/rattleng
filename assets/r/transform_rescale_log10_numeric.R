var <- SELECTED_VAR

newvar <- paste("R10_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Take a log10 transform of the variable - treat -Inf as NA.

ds[[newvar]] <-  log10(ds[[var]]) 
ds[ds[[newvar]] == -Inf & ! is.na(ds[[newvar]]), newvar] <- NA
