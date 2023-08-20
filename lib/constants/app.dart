/// App-Wide Constants for RattleNG
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
// Licensed under the GNU General Public License, Version 3 (the "License");
///
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

/// Project assets folder path used in the app.

const String assetsPath = 'assets';

const String rattleWelcome = '$assetsPath/markdown/rattle_welcome.md';

const String logIntro = '$assetsPath/markdown/log_intro.md';

final String cmdInitialMessage = """\
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
