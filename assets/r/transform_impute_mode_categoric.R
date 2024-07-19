var    <- SELECTED_VAR
newvar <- paste("IMO_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Change all NAs to the modal value (not advisable).

ds[[newvar]][is.na(ds[[var]])] <- modalvalue(ds[[var]], na.rm=TRUE)
