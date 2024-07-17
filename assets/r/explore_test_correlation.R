# Perform Test 

# Use the fBasics package for statistical tests.

library(fBasics, quietly=TRUE)

# Perform the test.

correlationTest(na.omit(crs$dataset[, "MinTemp"]), na.omit(crs$dataset[, "MaxTemp"]))

