/// Test WEATHER dataset EXPLORE tab VISUAL feature.
//
// Time-stamp: <Friday 2024-12-27 16:07:01 +1100 Graham Williams>
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
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/visual/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';

import 'utils/goto_next_page.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Weather Explore Visual.', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await loadDemoDataset(tester);

    await navigateToTab(tester, 'Explore');

    await navigateToFeature(tester, 'Visual', VisualPanel);

    await tapButton(tester, 'Generate Plots');

    await gotoNextPage(tester);
    final boxPlotFinder = find.textContaining('Box Plot');
    expect(boxPlotFinder, findsNWidgets(2)); // Title and CheckBox
    final boxImageFinder = find.byType(ImagePage);
    expect(boxImageFinder, findsOneWidget);

    await gotoNextPage(tester);
    final densityImageFinder = find.byType(ImagePage);
    expect(densityImageFinder, findsOneWidget);

    await gotoNextPage(tester);
    final cumulativeImageFinder = find.byType(ImagePage);
    expect(cumulativeImageFinder, findsOneWidget);

    await gotoNextPage(tester);
  });
}
