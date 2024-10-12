/// Gloabl variable status as text for the status bar.
///
/// Time-stamp: <Thursday 2024-10-10 08:17:15 +1100 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
/// Authors: Graham Williams
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final scriptProvider = StateProvider<String>(
  (ref) => '''# An R script to replicate your Rattle session.
#
# Copyright (C) 2023-2024, Togaware Pty Ltd.
#
# TIMESTAMP
#
# Rattle version VERSION.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
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
# Rattle Author: Graham.Williams@togaware.com
''',
);
