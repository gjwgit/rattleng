installed_pkgs <- installed.packages()  # Get list of installed packages

# Loop over packages and collect datasets
package_datasets <- lapply(installed_pkgs[, "Package"], function(pkg) {
tryCatch({
    # Load the package and get datasets
    # library(pkg, character.only = TRUE)
    datasets <- data(package = pkg)$results[, 3]  # Dataset names from the package
    return(datasets)
}, error = function(e) NULL)
})

# Create a named list where each element is a package's datasets
names(package_datasets) <- installed_pkgs[, "Package"]

# filter out package with no datasets
package_datasets_cleaned <- package_datasets[sapply(package_datasets, function(x) length(x) > 0)]

# all_datasets <- unlist(package_datasets)

# all_datasets
