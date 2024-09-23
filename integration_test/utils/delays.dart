/// Constant delays as used for testing.
//
// Time-stamp: <Monday 2024-09-23 12:20:12 +1000 Graham Williams>
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

/// We use a <pause> duration to optionally allow the tester to view the testing
/// interactively. A 2s delay is good for a quicker interactive, 5s is good to
/// review each screen, 10s is useful for development, thoug ha little slow. Set
/// as 0s for no pause as we do in the qtests. The pause should not be required
/// for the test to succeed and is handy only when running interactively. The
/// PAUSE environment variable can be used to override the default PAUSE
/// conveniently. If a test works when PAUSE is non-zero but fails when it is
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
///
/// If a test works when <pause> is non-zero but fails when it is zero then you
/// probably need to use a <delay> or a <hack> rather than a <pause>.

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));

/// The default <delay> can be used where a delay is always useful. We use a
/// default here of 2s though we have previously tried 1s, seems 2s is more
/// likely to be enough.

const Duration delay = Duration(seconds: 2);

/// 20240902 gjw There are currently times when we need to wait for the R Script
/// to finish in the current architecture which needs to be fixed,
/// eventually. For now we introduce a <hack> delay. By naming the delay as a
/// <hack> we are marking it as a delay that we want to com back and fix some
/// time.

const Duration hack = Duration(seconds: 10);

/// TODO 20240922 zy DO WE NEED longHack?
///
/// 20240922 Rather than introducing a <longHack> @Zheyuan, unless there is a
/// good reason that you explain here, please just use multiple <hack>
/// delays. Also, please comment when you add things like this to avoid others
/// having to waste their time.

const Duration longHack = Duration(seconds: 25);
