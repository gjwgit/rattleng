# Rattle Scripts: Evaluate executed models.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2024-10-07 17:03:05 +1100 Graham Williams>
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
# Author: Zheyuan Xu

if(TREE_EXECUTED_EVALUATE){
  trds$pr <- predict(model_rpart, newdata=trds, type="class")

  # Generate the confusion matrix showing counts.

  print('Error matrix for the Decision Tree model (counts)')

  cem <- rattle::errorMatrix(trds[[target]], trds$pr, count=TRUE)

  print(cem)

  # Generate the confusion matrix showing proportions.

  print('Error matrix for the Decision Tree model (proportions)')

  per <- rattle::errorMatrix(trds[[target]], trds$pr)

  print(per)

  # Calculate the overall error percentage.

  cat(100-sum(diag(per), na.rm=TRUE))

  # Calculate the averaged class error percentage.

  cat(mean(per[,"Error"], na.rm=TRUE))
}
