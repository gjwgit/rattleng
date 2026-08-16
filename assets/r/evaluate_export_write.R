# Write the exported evaluation results out as a CSV file.
#
# Copyright (C) 2026, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Sunday 2026-08-16 12:30:00 +1000 Graham Williams>
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
# Author: Graham Williams

# Rattle timestamp: <TIMESTAMP>

if (! exists("export_result"))
{
  cat("EXPORT FAILED: there is nothing to export.\n")
} else {

  write.csv(export_result, "<EXPORT_FILENAME>", row.names=FALSE)

  cat("Exported", nrow(export_result), "observations and",
      ncol(export_result), "columns to:\n<EXPORT_FILENAME>\n")

  cat("Columns:", paste(names(export_result), collapse=", "), "\n")
}
