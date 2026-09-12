import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app3/Provider/favorite_provider.dart';
import 'package:recipe_app3/Provider/quantity.dart';
import 'package:recipe_app3/Views/recipe_detail_screen.dart';
import 'package:recipe_app3/models/recipe_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RecipeDetailScreen displays recipe info and scales servings', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final testRecipe = RecipeModel(
      id: 'test_recipe_1',
      name: 'Lavender Berry Smoothie',
      image: '',
      cal: '190',
      time: '10',
      rate: '4.9',
      reviews: '24',
      category: 'Breakfast',
      ingredientsAmount: [100.0, 50.0],
      ingredientsName: ['Fresh Blueberries', 'Oat Milk'],
      ingredientsImage: ['', ''],
      description: 'A delicious test recipe.',
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => QuantityProvider()),
        ],
        child: MaterialApp(
          home: RecipeDetailScreen(recipe: testRecipe),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify recipe title & category
    expect(find.text('Lavender Berry Smoothie'), findsOneWidget);
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('190 Cal'), findsOneWidget);

    // Verify ingredients and base amount
    expect(find.text('Fresh Blueberries'), findsOneWidget);
    expect(find.text('100 g'), findsOneWidget);

    // Tap '+' icon to increase servings
    final addIcon = find.byIcon(Iconsax.add);
    expect(addIcon, findsOneWidget);
    await tester.tap(addIcon);
    await tester.pump();

    // Verify amount scaled from 100g to 200g
    expect(find.text('200 g'), findsOneWidget);
  });
}
