var    <- SELECTED_VAR
newvar <- paste("IZR_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Change all NAs to 0.

ds[[newvar]][is.na(ds[[var]])] <- 0
