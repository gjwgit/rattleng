var    <- SELECTED_VAR
newvar <- paste("IMN_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Change all NAs to the mean value (not advisable).

ds[[newvar]][is.na(ds[[var]])] <- mean(ds[[var]], na.rm=TRUE)
