library(reshape)   # Use the 'rescaler' function.

# Rescale <SELECTED_VAR>.

ds[["RIN<INTERVAL>_<SELECTED_VAR>"]] <- ds[["<SELECTED_VAR>"]]

# Rescale to 0 to <INTERVAL> within each group.

ds[["RIN<INTERVAL>_<SELECTED_VAR>"]] <-
    rattle::rescale.by.group(ds[["<SELECTED_VAR>"]], type="irank", itop=<INTERVAL>)

glimpse(ds)
summary(ds)
