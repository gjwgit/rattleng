var    <- SELECTED_VAR
newvar <- paste("IMD_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Change all NAs to the median (not advisable).

ds[[newvar]][is.na(ds[[var]])] <- median(ds[[var]], na.rm=TRUE)
