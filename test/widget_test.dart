import 'package:flutter_test/flutter_test.dart';
import 'package:bondhu/main.dart';

void main() {
  testWidgets('Bondhu app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const BondhuApp());

    expect(find.text('Bondhu'), findsOneWidget);
  });
}
