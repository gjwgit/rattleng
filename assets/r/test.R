# Perform All Tests

# Use the fBasics package for statistical tests.

if(!require(fBasics)) install.packages("fBasics")

# Perform the test.

#miss <- union(attr(na.omit(ds[,"SELECTED_VAR"]), "na.action"),
#              attr(na.omit(ds[,"SELECTED2_VAR"]), "na.action"))

#correlationTest(na.omit(ds[-miss, "SELECTED_VAR"]),
#                na.omit(ds[-miss, "SELECTED2_VAR"]))

fBasics::correlationTest(ds$SELECTED_VAR, ds$SELECTED_2_VAR)

#ks2Test(na.omit(crs$dataset[crs$dataset[["RainTomorrow"]] == "No", "Rainfall"]), na.omit(crs$dataset[crs$dataset[["RainTomorrow"]] == "Yes", "Rainfall"]))

fBasics::ks2Test(na.omit(ds$SELECTED_VAR), na.omit(ds$SELECTED_2_VAR))

#ks2Test(na.omit(crs$dataset[crs$dataset[["RainTomorrow"]] == "No", "Rainfall"]), na.omit(crs$dataset[crs$dataset[["RainTomorrow"]] == "Yes", "Rainfall"]))

wilcox.test(na.omit(ds$SELECTED_VAR), na.omit(ds$SELECTED_2_VAR))

# locationTest(na.omit(crs$dataset[, "Rainfall"]), na.omit(crs$dataset[, "MaxTemp"]))

fBasics::locationTest(na.omit(ds$SELECTED_VAR), na.omit(ds$SELECTED_2_VAR))

# varianceTest(na.omit(crs$dataset[, "Rainfall"]), na.omit(crs$dataset[, "MaxTemp"]))

fBasics::varianceTest(na.omit(ds$SELECTED_VAR), na.omit(ds$SELECTED_2_VAR))
