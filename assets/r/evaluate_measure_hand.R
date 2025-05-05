# Use `actual_va` and `probability` for David Hand's classifier evaluation.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2025-05-05 16:56:25 +1000 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Zheyuan Xu, Graham Williams

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

title <- glue(
  "H-Measures - {mdesc} - ",
  "{mtype} {basename('<FILENAME>')} ",
  "**{dtype}** ", <TARGET_VAR>
)

# Evaluate the model using HMeasure.

results <- hmeasure::HMeasure(true.class=actual_va, scores=probability)

# Create a single SVG file that displays all 4 plots.
##
## Be sure to keep the following on a single line to avoid orphons
## when we strip the `svg` line on saving the SCRIPT.

svg(filename=glue("<TEMPDIR>/evaluate_{mtype}_hand_{dtype}.svg"), width=11, height=8)
par(mfrow=c(2, 2))
hmeasure::plotROC(results, which=1)
hmeasure::plotROC(results, which=2)
hmeasure::plotROC(results, which=3)
hmeasure::plotROC(results, which=4)
mtext(title, outer=TRUE, cex=1, line=-1, font=2)
dev.off()
