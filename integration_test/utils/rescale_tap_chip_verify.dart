import 'package:flutter_test/flutter_test.dart';
import 'delays.dart';
import 'goto_next_page.dart';
import 'press_first_button.dart';
import 'scroll_until.dart';
import 'tap_chip.dart';
import 'verify_page.dart';
import 'verify_selectable_text.dart';

Future<void> rescale_tap_chip_verify(
  WidgetTester tester,
  String chipText,
  String variableName,
  List<String> expectedStats,
) async {
  await tapChip(tester, chipText);
  await pressFirstButton(tester, 'Rescale Variable Values');
  await tester.pump(delay);
  await gotoNextPage(tester);

  await verifyPage('Dataset Summary', variableName);
  await scrollUntilFindKey(tester, 'text_page');
  await verifySelectableText(tester, expectedStats);
}
