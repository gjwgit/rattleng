/// Support untility for checking if a string is a dataset from a pacakge
//
// Time-stamp: <Friday 2024-12-20 16:37:54 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
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
/// Authors: Yixiang Yin


bool isFromPackage(String input) {
  // Define the regular expression pattern: a string followed by '::' followed by another string
  RegExp regExp = RegExp(r'^[^:]+::[^:]+$');
  
  // Use the RegExp to check if the input matches the pattern
  return regExp.hasMatch(input);
}
