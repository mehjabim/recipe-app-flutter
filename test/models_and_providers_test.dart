import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app3/Provider/quantity.dart';
import 'package:recipe_app3/Provider/favorite_provider.dart';
import 'package:recipe_app3/services/mock_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuantityProvider Tests', () {
    test('Calculates and scales ingredients dynamically with servings multiplier', () {
      final provider = QuantityProvider();
      provider.setBaseIngredientAmounts([100.0, 50.5, 20.0]);

      expect(provider.currentNumber, 1);
      expect(provider.updateIngredientAmounts, ['100', '50.5', '20']);

      provider.increaseQuantity();
      expect(provider.currentNumber, 2);
      expect(provider.updateIngredientAmounts, ['200', '101', '40']);

      provider.decreaseQuantity();
      expect(provider.currentNumber, 1);

      // Should not go below 1
      provider.decreaseQuantity();
      expect(provider.currentNumber, 1);
    });
  });

  group('FavoriteProvider & MockDataService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('MockDataService returns default categories and recipes correctly', () {
      final recipes = MockDataService.getAllRecipes();
      expect(recipes.isNotEmpty, true);
      expect(MockDataService.defaultCategories.length, greaterThan(3));

      final breakfastRecipes = MockDataService.getRecipesByCategory('Breakfast');
      expect(breakfastRecipes.isNotEmpty, true);
    });

    test('FavoriteProvider toggles favorites and reflects membership', () {
      final favProvider = FavoriteProvider();
      expect(favProvider.isFavorite('recipe_1'), false);

      favProvider.toggleFavorite('recipe_1');
      expect(favProvider.isFavorite('recipe_1'), true);

      favProvider.toggleFavorite('recipe_1');
      expect(favProvider.isFavorite('recipe_1'), false);
    });
  });
}
