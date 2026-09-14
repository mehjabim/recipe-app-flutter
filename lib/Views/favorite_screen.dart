import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../Provider/favorite_provider.dart';
import '../Utils/constants.dart';
import '../Widget/food_items_display.dart';
import '../models/recipe_model.dart';
import '../services/mock_data_service.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  Future<RecipeModel?> _resolveRecipe(String id) async {
    // 1. Check local catalog by ID or Name
    final all = MockDataService.getAllRecipes();
    for (final r in all) {
      if (r.id == id || r.name.toLowerCase() == id.toLowerCase()) {
        return r;
      }
    }

    // 2. If not found and Firebase is active, fetch from Firestore
    try {
      if (Firebase.apps.isNotEmpty) {
        final doc = await FirebaseFirestore.instance.collection('recipes').doc(id).get();
        if (doc.exists && doc.data() != null) {
          return RecipeModel.fromFirestore(doc);
        }
      }
    } catch (_) {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final favoriteIds = favProvider.favorites;

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text('Saved Favorites'),
        elevation: 0,
      ),
      body: favoriteIds.isEmpty
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
              itemCount: favoriteIds.length,
              itemBuilder: (context, index) {
                final favId = favoriteIds[index];

                return FutureBuilder<RecipeModel?>(
                  future: _resolveRecipe(favId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kprimaryColor,
                            ),
                          ),
                        ),
                      );
                    }

                    final recipe = snapshot.data;
                    if (recipe != null) {
                      return FoodItemsDisplay(
                        recipe: recipe,
                        isGrid: true,
                      );
                    }

                    // Fallback for orphaned id
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.danger, color: Colors.orangeAccent, size: 28),
                          const SizedBox(height: 8),
                          const Text(
                            'Item Unavailable',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => favProvider.toggleFavorite(favId),
                            child: const Text('Remove', style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
