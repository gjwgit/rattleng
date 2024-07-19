var    <- SELECTED_VAR
newvar <- paste("ICN_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Add a new category 'MISSING_CATEGORIC_VALUE' to the variable

levels(ds[[newvar]]) <- c(levels(ds[[newvar]]), "MISSING_CATEGORIC_VALUE")

# Change all NAs to the constant value: MISSING_CATEGORIC_VALUE

ds[[newvar]][is.na(ds[[var]])] <- "MISSING_CATEGORIC_VALUE"
