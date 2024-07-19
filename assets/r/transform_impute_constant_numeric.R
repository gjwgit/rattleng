var    <- SELECTED_VAR
newvar <- paste("ICN_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Change all NAs to the constant: 99999.

ds[[newvar]][is.na(ds[[var]])] <- MISSING_NUMERIC_VALUE 
