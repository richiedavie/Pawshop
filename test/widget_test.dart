import 'package:flutter_test/flutter_test.dart';
import 'package:pawshop/main.dart';

void main() {
  testWidgets('PawShop App loads home title test', (WidgetTester tester) async {
    await tester.pumpWidget(const PawShopApp());
    expect(find.text('PawShop'), findsOneWidget);
  });
}
