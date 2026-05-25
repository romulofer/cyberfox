import 'package:flutter_test/flutter_test.dart';
import 'package:cyberfox/main.dart';

void main() {
  testWidgets('App renders without crashing', (tester) async {
    await tester.pumpWidget(const CyberfoxApp());
    expect(find.text('Cyberfox'), findsOneWidget);
  });
}
