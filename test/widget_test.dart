import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app3/main.dart';

void main() {
  testWidgets('RecipeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());

    expect(find.text('Mindful Recipes'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
