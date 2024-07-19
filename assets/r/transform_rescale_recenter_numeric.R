# Transform variables by rescaling. 

# Rescale SELECTED_VAR.

var <- SELECTED_VAR

newvar <- paste("RRC_", SELECTED_VAR, sep="")

ds[[newvar]] <- crs$dataset[[var]]

# Recenter and rescale the data around 0.

ds[[newvar]] <- scale(ds[[var]])[,1]
