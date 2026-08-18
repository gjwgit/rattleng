/// Constant delays as used for testing.
//
// Time-stamp: <Friday 2025-08-15 13:43:03 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://opensource.org/license/gpl-3-0
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
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams

library;

/// We use an [interact] duration to optionally allow the tester to view the testing
/// interactively. A 2s delay is good for a quicker interactive, 5s is good to
/// review each screen, 10s is useful for development, thoug ha little slow. Set
/// as 0s for no interact as we do in the qtests. The interact should not be required
/// for the test to succeed and is handy only when running interactively. The
/// INTERACT environment variable can be used to override the default INTERACT
/// conveniently. If a test works when INTERACT is non-zero but fails when it is
///
/// flutter test --device-id linux --dart-define=INTERACT=0 integration_test/app_test.dart
///
/// If a test works when [interact] is non-zero but fails when it is zero then you
/// probably need to use a delay or a hack rather than a [interact].

const String envINTERACT = String.fromEnvironment(
  'INTERACT',
  defaultValue: '0',
);
final Duration interact = Duration(seconds: int.parse(envINTERACT));

/// The default delay can be used where a delay is always useful. We use a
/// default here of 2s though we have previously tried 1s, seems 2s is more
/// likely to be enough.

const Duration delay = Duration(seconds: 2);

/// 20260818 gjw The `hack` and `longHack` delays are gone. They existed to wait
/// for an R script to finish, which is now done by `waitForR()` in
/// `utils/wait_for_r.dart`, watching the same traffic light the app itself
/// shows. That waits as long as the work takes rather than a fixed 10s or 25s,
/// so a slow machine is not left short and a fast one is not left waiting. The
/// note that came with `hack` asked for exactly this.
///
/// Use [delay] for the GUI and `waitForR()` for R.
