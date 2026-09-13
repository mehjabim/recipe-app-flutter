import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../Provider/favorite_provider.dart';
import '../Utils/constants.dart';
import '../Widget/food_items_display.dart';
import '../services/mock_data_service.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final allRecipes = MockDataService.getAllRecipes();
    final favoriteRecipes = allRecipes.where((r) => favProvider.isFavorite(r.id)).toList();

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text('Saved Favorites'),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: kBannerColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Iconsax.heart_slash,
                          size: 46,
                          color: kBannerColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Saved Favorites Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore nourishing recipes on the home page and tap the heart icon to save your personal favorites here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextSecondaryColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return FoodItemsDisplay(
                  recipe: favoriteRecipes[index],
                );
              },
            ),
    );
  }
}
