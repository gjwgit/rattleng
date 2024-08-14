# Bin the SELECTED_VAR into NUMBER bins using equal widths.

ds[["BE_SELECTED_VAR_NUMBER"]] <- cut(ds[["SELECTED_VAR"]], NUMBER)
