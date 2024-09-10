/// Constant delays as used for testing.
//
// Time-stamp: <Monday 2024-09-02 07:16:30 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

/// We use a <pause> duration to allow the tester to view/interact with the
/// testing interactively. 2s ig good for a quicker interactive, 5s is good to
/// review each screen, 10s is useful for development. Set as 0s for no pause. This
/// is not necessary but it is handy when running interactively for the user
/// running the test to see the widgets for added assurance. The PAUSE
/// environment variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
///

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));

/// The default dlay where a delay is always useful.

const Duration delay = Duration(seconds: 2);

/// 20240902 gjw There are currently times when we need to wait for the R Script
/// to finish in the current architecture which needs to be fixed. For now we
/// introduce a <hack> delay.

const Duration hack = Duration(seconds: 10);

const Duration longHack = Duration(seconds: 25);
