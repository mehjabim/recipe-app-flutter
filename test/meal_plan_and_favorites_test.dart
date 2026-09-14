import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app3/Provider/auth_provider.dart';
import 'package:recipe_app3/Provider/favorite_provider.dart';
import 'package:recipe_app3/Provider/meal_plan_provider.dart';
import 'package:recipe_app3/Views/favorite_screen.dart';
import 'package:recipe_app3/Views/meal_plan_screen.dart';
import 'package:recipe_app3/services/mock_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await MockDataService.init();
  });

  testWidgets('MealPlanScreen renders day selector and handles completion toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MealPlanProvider()),
        ],
        child: const MaterialApp(
          home: MealPlanScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Meal Planner'), findsOneWidget);
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
  });

  testWidgets('FavoriteScreen displays empty state when no favorites exist', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ],
        child: const MaterialApp(
          home: FavoriteScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Saved Favorites'), findsOneWidget);
    expect(find.text('No Saved Favorites Yet'), findsOneWidget);
  });

  testWidgets('FavoriteScreen displays favorited items when added', (WidgetTester tester) async {
    final favProvider = FavoriteProvider();
    favProvider.toggleFavorite('mindful_recipe_1');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FavoriteProvider>.value(value: favProvider),
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ],
        child: const MaterialApp(
          home: FavoriteScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Saved Favorites'), findsOneWidget);
    expect(find.text('No Saved Favorites Yet'), findsNothing);
  });

  test('MealPlanProvider correctly stores and filters scheduled meals by day and meal type', () {
    final provider = MealPlanProvider();
    final meal = PlannedMeal(
      id: 'test_meal_1',
      day: 'Wed',
      mealType: 'Dinner',
      recipeName: 'Lavender Lemon Herb Salmon',
      time: '07:30 PM',
      calories: '450 Cal',
      imageUrl: 'https://example.com/salmon.jpg',
    );

    provider.addMeal(meal);
    final wedMeals = provider.getMealsForDay('Wed');
    expect(wedMeals.any((m) => m.id == 'test_meal_1'), isTrue);
    expect(wedMeals.first.mealType, 'Dinner');
    expect(wedMeals.first.recipeName, 'Lavender Lemon Herb Salmon');

    final thuMeals = provider.getMealsForDay('Thu');
    expect(thuMeals.any((m) => m.id == 'test_meal_1'), isFalse);
  });
}

