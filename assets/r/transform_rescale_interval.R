library(reshape)   # Use the 'rescaler' function.

# Rescale <SELECTED_VAR> by rank into the integer interval 0 to <INTERVAL>-1.

ds[["RIN_<SELECTED_VAR>_<INTERVAL>"]] <-
    rattle::rescale.by.group(ds[["<SELECTED_VAR>"]], type="irank", itop=<INTERVAL>)

glimpse(ds)
summary(ds)
