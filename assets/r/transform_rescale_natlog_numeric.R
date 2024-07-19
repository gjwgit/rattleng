# Transform variables by rescaling. 

var <- SELECTED_VAR

newvar <- paste("RLG_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Take a log transform of the variable - treat -Inf as NA.

ds[[newvar]] <-  log(ds[[var]]) 
ds[ds[[newvar]] == -Inf & ! is.na(ds[[newvar]]), newvar] <- NA
