var    <- SELECTED_VAR
newvar <- paste("IZR_", SELECTED_VAR, sep="")

ds[[newvar]] <- ds[[var]]

# Add a new category 'Missing' to the variable

levels(ds[[newvar]]) <- c(levels(ds[[newvar]]), "Missing")

# Change all NAs to 'Missing'

ds[[newvar]][is.na(ds[[var]])] <- "Missing"
