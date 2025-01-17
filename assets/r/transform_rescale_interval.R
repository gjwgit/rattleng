# The 'reshape' package provides the 'rescaler' function.

# library(reshape, quietly=TRUE)

# Rescale <SELECTED_VAR>.

ds[["<RIN_SELECTED_VAR_INTERVAL>"]] <- ds[["<SELECTED_VAR>"]]

# Rescale to 0 to <INTERVAL> within each group.

ds[["<RIN_SELECTED_VAR_INTERVAL>"]] <-
    rattle::rescale.by.group(ds[["<SELECTED_VAR>"]], type="irank", itop=<INTERVAL>)

glimpse(ds)
summary(ds)
