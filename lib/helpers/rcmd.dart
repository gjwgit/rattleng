var cmd_log_intro = """\
The log captures all interactions with Rattle as an R script.

You can Save the log to a file (e.g., 'model.R') to run in R, independent of\
Rattle.To run the file as an R script use the Rscript command. Alternatively,\
through the R Console or RStudio run the command using "source('model.R')".
""";

var cmd_initial_message = """\
#=======================================================================
#
# Rattle is Copyright (c) 2006-${DateTime.now().year} Togaware Pty Ltd.
# It is free (as in libre) open source software.
# It is licensed under the GNU General Public License,
# Version 3. Rattle comes with ABSOLUTELY NO WARRANTY.
# Rattle was written by Graham Williams with contributions
# from others as acknowledged in 'library(help=rattle)'.
# Visit https://rattle.togaware.com/ for details.
#
#=======================================================================
#
# Rattle timestamp: ${DateTime.now()} x86_64-pc-linux-gnu 
#
# Rattle version 6.0.0 user 'gjw'
#
# We begin most scripts by loading the required packages.
# Here are some initial packages to load and others will be
# identified as we proceed through the script. When writing
# our own scripts we often collect together the library
# commands at the beginning of the script here.

library(rattle)   # Access the weather dataset and utilities.
library(magrittr) # Utilise %>% and %<>% pipeline operators.
  
# This log generally records the process of building a model. 
# However, with very little effort the log can also be used 
# to score a new dataset. The logical variable 'building' 
# is used to toggle between generating transformations, 
# when building a model and using the transformations, 
# when scoring a dataset.

building <- TRUE
scoring  <- ! building

# A pre-defined value is used to reset the random seed 
# so that results are repeatable.

set.seed(42)
""";

