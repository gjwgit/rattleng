import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattle/app.dart';

Future<ProviderContainer> initApp(WidgetTester tester) async {
  final container = ProviderContainer();
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RattleApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}
