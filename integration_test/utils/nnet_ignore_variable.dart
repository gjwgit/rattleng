/// Variables to be set as IGNORE before building NNET model.
//
// Time-stamp: <Tuesday 2024-09-10 20:39:07 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu

library;

/// List of specific variables that should have their role automatically
/// set to 'Ignore' in demo dataset. These are factors and don;t play well
/// with nnet.

final List<String> demoVariablesToIgnore = [];

/// List of specific variables that should have their role manually set to
/// 'Ignore'. These are factors and don;t play well with nnet.

final List<String> demoVariablesManuallyIgnore = [
  'wind_gust_dir',
  'wind_dir_9am',
  'wind_dir_3pm',
];

/// List of specific variables that should have their role set to 'Ignore' in
/// large dataset. These are factors and don;t play well with nnet.

final List<String> largeVariablesToIgnore = [
  'rec_id',
  'ssn',
  'first_name',
  'middle_name',
  'last_name',
  'birth_date',
  'medicare_number',
  'street_address',
  'suburb',
  'postcode',
  'phone',
  'email',
  'clinical_notes',
  'consultation_timestamp',
];
