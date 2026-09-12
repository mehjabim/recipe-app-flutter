import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../Provider/favorite_provider.dart';
import '../Utils/constants.dart';
import '../models/recipe_model.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?>? documentSnapshot;
  final RecipeModel? recipe;
  final VoidCallback? onTap;

  const FoodItemsDisplay({
    super.key,
    this.documentSnapshot,
    this.recipe,
    this.onTap,
  }) : assert(documentSnapshot != null || recipe != null);

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final data = (documentSnapshot?.data() as Map<String, dynamic>?) ?? {};

    final String itemId = recipe?.id ?? documentSnapshot?.id ?? "recipe";
    final String name = recipe?.name ?? (data['name']?.toString() ?? "Wholesome Dish");
    final String image = recipe?.image ?? (data['image']?.toString() ?? "");
    final String cal = recipe?.cal ?? (data['cal']?.toString() ?? "250");
    final String time = recipe?.time ?? (data['time']?.toString() ?? "20");
    final String rate = recipe?.rate ?? (data['rate']?.toString() ?? "4.9");
    final bool isFav = favProvider.isFavorite(itemId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: kprimaryColor.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Hero(
                    tag: 'recipe_image_$itemId',
                    child: image.isNotEmpty
                        ? Image.network(
                            image,
                            width: double.infinity,
                            height: 145,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 145,
                              color: kCardBgColor,
                              child: const Icon(Iconsax.image, color: kTextSecondaryColor, size: 36),
                            ),
                          )
                        : Container(
                            height: 145,
                            color: kCardBgColor,
                            child: const Icon(Iconsax.image, color: kTextSecondaryColor, size: 36),
                          ),
                  ),
                ),
                // Rating Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 3),
                        Text(
                          rate,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kTextPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => favProvider.toggleFavorite(itemId),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isFav ? Iconsax.heart5 : Iconsax.heart,
                          color: isFav ? kBannerColor : kTextSecondaryColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Calorie pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: kBannerColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Iconsax.flash_1, size: 12, color: kBannerColor),
                            const SizedBox(width: 3),
                            Text(
                              '$cal cal',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: kBannerColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Time pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: kprimaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Iconsax.clock, size: 12, color: kprimaryColor),
                            const SizedBox(width: 3),
                            Text(
                              '$time min',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: kprimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
