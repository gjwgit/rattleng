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

  group('cleanup ignored demo test:', () {
    testWidgets('test', (tester) async {
      app.main();
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

      // Tap the right arrow button to go to "variable role selection" page.

      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
      await tester.tap(rightArrowFinder);
      await tester.pumpAndSettle();
    });
  });
}
