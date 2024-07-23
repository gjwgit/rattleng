# Perform Test 

# Use the fBasics package for statistical tests.

library(fBasics, quietly=TRUE)

# Perform the test.

miss <- union(attr(na.omit(ds[,"SELECTED_VAR"]), "na.action"),
              attr(na.omit(ds[,"SELECTED2_VAR"]), "na.action"))

correlationTest(na.omit(ds[-miss, "SELECTED_VAR"]),
                na.omit(ds[-miss, "SELECTED2_VAR"]))
