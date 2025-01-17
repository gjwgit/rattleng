# Get a list of datasets in the installed packages.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-10-12 20:40:19 +1100 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but <WITHOUT>
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Yixiang Yin

# Get list of installed packages

installed_pkgs <- installed.packages()  

# Loop over packages and collect datasets

package_datasets <- lapply(installed_pkgs[, "Package"], function(pkg) {
tryCatch({
    datasets <- data(package = pkg)$results[, 3]  # Dataset names from the package
    return(datasets)
}, error = function(e) NULL)
})

# Create a named list where each element is a package's datasets

names(package_datasets) <- installed_pkgs[, "Package"]

# filter out package with no datasets

package_datasets_cleaned <- package_datasets[sapply(package_datasets, function(x) length(x) > 0)]

package_datasets_cleaned
# all_datasets <- unlist(package_datasets)

# all_datasets
