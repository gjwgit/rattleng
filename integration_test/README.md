# Guidelines

## Template

```
/// AUDIT dataset TREE model CTREE feature.

...

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AUDIT MODEL TREE CTREE:', () {
    testWidgets('load; build ctree; verify.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loadDemoDataset(tester, 'Audit');
	     ...
    });
  });
}
```
