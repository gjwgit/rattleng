import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/main.dart' as app;

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Dataset:', () {
    testWidgets('cleanup tab ignore test', (WidgetTester tester) async {
      app.main();

      // Trigger a frame. Finish animation and scheduled microtasks.
      await tester.pumpAndSettle();

      // Leave time to see the first page.
      await tester.pump(pause);

      final datasetButtonFinder = find.byType(DatasetButton);
      expect(datasetButtonFinder, findsOneWidget);
      await tester.pump(pause);

      final datasetButton = find.byType(DatasetButton);
      expect(datasetButton, findsOneWidget);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();

      await tester.pump(delay);

      final datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);

      final demoButton = find.text('Demo');
      expect(demoButton, findsOneWidget);

      await tester.tap(demoButton);
      await tester.pumpAndSettle();

      await tester.pump(pause);

      final dsPathTextFinder = find.byKey(datasetPathKey);
      expect(dsPathTextFinder, findsOneWidget);
      final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
      String filename = dsPathText.controller?.text ?? '';
      expect(filename, 'rattle::weather');

      // Find the right arrow button in the PageIndicator.
      final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
      expect(rightArrowFinder, findsOneWidget);

      // Tap the right arrow button to go to the variable role selection.
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Find the "Ignore" buttons and click the first four.
      final buttonFinder = find.text('Ignore');
      expect(
        buttonFinder,
        findsWidgets,
      ); // Check that multiple "Ignore" buttons exist

      // Tap the first four "Ignore" buttons found
      for (int i = 0; i < 4; i++) {
        await tester.tap(buttonFinder.at(i));
        await tester.pumpAndSettle();
      }

      // Navigate to the "Transform" tab.
      final transformTabFinder = find.text('Transform');
      expect(
        transformTabFinder,
        findsOneWidget,
      ); // Ensure the "Transform" tab exists.
      await tester.tap(transformTabFinder); // Tap the "Transform" tab.
      await tester.pumpAndSettle(); // Wait for the UI to update.

      // Navigate to the "Cleanup" sub-tab within the Transform tab.
      final cleanupSubTabFinder = find.text('Cleanup');
      expect(
        cleanupSubTabFinder,
        findsOneWidget,
      ); // Ensure the "Cleanup" sub-tab exists.
      await tester.tap(cleanupSubTabFinder); // Tap the "Cleanup" sub-tab.
      await tester.pumpAndSettle(); // Wait for the UI to update.

      // Locate the "Ignore" chip. Adjust the Finder if needed.
      final ignoreChipFinder =
          find.text('Ignored'); // Adjusted finder: search by text
      // Check if the Ignore text exists anywhere in the current widget tree.
      expect(
        ignoreChipFinder,
        findsOneWidget,
      ); // Ensure at least one "Ignore" widget exists.
      await tester
          .tap(ignoreChipFinder); // Tap on the single found "Ignore" chip.

      await tester.tap(ignoreChipFinder); // Tap on the "Ignore" chip.
      await tester
          .pumpAndSettle(); // Wait for the UI to settle after the interaction.

      // Tap the "Delete from Dataset" button.
      final deleteButtonFinder = find.text('Delete from Dataset');
      expect(
        deleteButtonFinder,
        findsOneWidget,
      ); // Ensure the "Delete from Dataset" button exists.
      await tester
          .tap(deleteButtonFinder); // Tap on the "Delete from Dataset" button.
      await tester.pumpAndSettle(); // Wait for the UI to settle.

      // Confirm the deletion by tapping the "Yes" button.
      final yesButtonFinder = find.text('Yes');
      expect(
        yesButtonFinder,
        findsOneWidget,
      ); // Ensure the "Yes" button exists.
      await tester.tap(
        yesButtonFinder,
      ); // Tap on the "Yes" button to confirm the deletion.
      await tester
          .pumpAndSettle(); // Wait for the UI to settle after the interaction.

      // Go to the next page and confirm that the deleted variables are not listed.
      await tester.tap(rightArrowFinder); // Tap to go to the next page.
      await tester.pumpAndSettle(); // Wait for the UI to settle.

      // Check that deleted variables are not listed on the next page.
      final deletedVariables = ['date', 'min_temp', 'max_temp', 'rainfall'];
      for (String variable in deletedVariables) {
        final deletedVariableFinder = find.text(variable);
        expect(
          deletedVariableFinder,
          findsNothing,
        ); // Ensure the deleted variable is not listed.
      }

      // Navigate to "EXPLORE" -> "VISUAL".
      final exploreTabFinder = find.text('Explore');
      expect(
        exploreTabFinder,
        findsOneWidget,
      ); // Ensure the "Explore" tab exists.
      await tester.tap(exploreTabFinder); // Tap on the "Explore" tab.
      await tester.pumpAndSettle(); // Wait for the UI to settle.

      final visualSubTabFinder = find.text('Visual');
      expect(
        visualSubTabFinder,
        findsOneWidget,
      ); // Ensure the "Visual" sub-tab exists.
      await tester.tap(visualSubTabFinder); // Tap on the "Visual" sub-tab.
      await tester.pumpAndSettle(); // Wait for the UI to settle.

      // Check that 'evaporation' is the selected variable.
      final evaporationSelectedFinder = find
          .text('evaporation')
          .hitTestable(); // Check 'evaporation' is selected.
      expect(
        evaporationSelectedFinder,
        findsOneWidget,
      ); // Ensure 'evaporation' is selected.

      await tester.tap(evaporationSelectedFinder); // Tap on the dropdown menu.
      await tester.pumpAndSettle(); // Wait for the dropdown options to appear.

      // Check that deleted variables are not in the dropdown options.
      for (String variable in deletedVariables) {
        final dropdownOptionFinder =
            find.text(variable); // Find each variable in the dropdown options.
        expect(
          dropdownOptionFinder,
          findsNothing,
        ); // Ensure the deleted variable is not listed in the dropdown options.
      }

      // Navigate to the "Dataset" tab.
      final datasetTabFinder = find.text(
        'Dataset',
      ); // Assuming the tab can be identified by its text 'Dataset'.
      expect(
        datasetTabFinder,
        findsOneWidget,
      ); // Ensure the "Dataset" tab exists.
      await tester.tap(datasetTabFinder); // Tap on the "Dataset" tab.
      await tester.pumpAndSettle(); // Wait for the UI to settle.
      // Tap the right arrow button to go to the variable role selection.
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();

      // Find the "Ignore" buttons and click the first two.
      final button2Finder = find.text('Ignore');
      expect(
        button2Finder,
        findsWidgets,
      ); // Check that multiple "Ignore" buttons exist

      // Tap the first two "Ignore" buttons found
      for (int i = 0; i < 2; i++) {
        await tester.tap(button2Finder.at(i));
        await tester.pumpAndSettle();
      }

      // Navigate to the "Transform" tab.
      await tester.tap(transformTabFinder); // Tap the "Transform" tab.
      await tester.pumpAndSettle(); // Wait for the UI to update.

      // Navigate to the "Cleanup" sub-tab within the Transform tab.

      await tester.tap(cleanupSubTabFinder); // Tap the "Cleanup" sub-tab.
      await tester.pumpAndSettle(); // Wait for the UI to update.
      // Tap on the single found "Ignore" chip.
      await tester.tap(ignoreChipFinder);

      await tester.tap(ignoreChipFinder); // Tap on the "Ignore" chip.
      await tester
          .pumpAndSettle(); // Wait for the UI to settle after the interaction.

      // Tap the "Delete from Dataset" button.
      await tester
          .tap(deleteButtonFinder); // Tap on the "Delete from Dataset" button.
      await tester.pumpAndSettle(); // Wait for the UI to settle.

      // Confirm the deletion by tapping the "Yes" button.
      await tester.tap(
        yesButtonFinder,
      ); // Tap on the "Yes" button to confirm the deletion.
      await tester
          .pumpAndSettle(); // Wait for the UI to settle after the interaction.

      // Navigate to "EXPLORE" -> "VISUAL".
      await tester.tap(exploreTabFinder); // Tap on the "Explore" tab.
      await tester.pumpAndSettle(); // Wait for the UI to settle.
      await tester.tap(visualSubTabFinder); // Tap on the "Visual" sub-tab.
      await tester.pumpAndSettle(); // Wait for the UI to settle.

      // Check that 'wind_gust_speed' is the selected variable.
      final windGustSpeedFinder = find.text('wind_gust_speed').hitTestable();
      expect(
        windGustSpeedFinder,
        findsOneWidget,
      );
    });
  });
}
