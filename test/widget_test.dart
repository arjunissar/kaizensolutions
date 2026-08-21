import 'package:flutter_test/flutter_test.dart';
import 'package:kaizensolutions/app.dart';

void main() {
  testWidgets('Home page renders brand name', (WidgetTester tester) async {
    await tester.pumpWidget(const KaizenApp());
    await tester.pumpAndSettle();
    expect(find.text('Kaizen Solutions Notebooks'), findsOneWidget);
  });
}
