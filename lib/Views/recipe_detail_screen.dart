import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../Provider/favorite_provider.dart';
import '../Provider/meal_plan_provider.dart';
import '../Provider/quantity.dart';
import '../Utils/constants.dart';
import '../Widget/my_icon_button.dart';
import '../Widget/quantity_increment_decrement.dart';
import '../models/recipe_model.dart';
import '../services/mock_data_service.dart';
import 'meal_plan_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?>? documentSnapshot;
  final RecipeModel? recipe;

  const RecipeDetailScreen({
    super.key,
    this.documentSnapshot,
    this.recipe,
  }) : assert(documentSnapshot != null || recipe != null);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    final data = (widget.documentSnapshot?.data() as Map<String, dynamic>?) ?? {};
    final rawAmounts = widget.recipe?.ingredientsAmount ?? data['ingredientsAmount'];

    List<double> baseAmounts = [];
    if (rawAmounts is List) {
      baseAmounts = rawAmounts
          .map<double>((amount) => double.tryParse(amount.toString()) ?? 0.0)
          .toList();
    }
    if (baseAmounts.isEmpty) {
      baseAmounts = [100.0, 50.0, 30.0];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<QuantityProvider>(context, listen: false)
            .setBaseIngredientAmounts(baseAmounts);
      }
    });
  }

  void _showScheduleModal({
    required BuildContext context,
    required String recipeName,
    required String calories,
    required String imageUrl,
  }) {
    String selectedDay = "Mon";
    String selectedMealType = "Breakfast";
    String scheduledTime = "08:00 AM";

    final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final List<String> dayNames = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    final List<String> mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetContext, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
              left: 22.0,
              right: 22.0,
              top: 20.0,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Handle
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kBorderColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Modal Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kprimaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.calendar_add, color: kprimaryColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Schedule to Meal Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextPrimaryColor,
                            ),
                          ),
                          Text(
                            recipeName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: kTextSecondaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Day Selection
                const Text(
                  'Select Day of the Week',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(days.length, (index) {
                      final dayCode = days[index];
                      final isSelected = selectedDay == dayCode;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(days[index]),
                          selected: isSelected,
                          selectedColor: kprimaryColor,
                          backgroundColor: kbackgroundColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : kTextPrimaryColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                selectedDay = dayCode;
                              });
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                // Meal Type Selection
                const Text(
                  'Select Meal Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: mealTypes.map((type) {
                    final isSelected = selectedMealType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: kBannerColor,
                      backgroundColor: kbackgroundColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : kTextPrimaryColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 13,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setModalState(() {
                            selectedMealType = type;
                            if (type == "Breakfast") scheduledTime = "08:00 AM";
                            if (type == "Lunch") scheduledTime = "01:00 PM";
                            if (type == "Dinner") scheduledTime = "07:30 PM";
                            if (type == "Snack") scheduledTime = "04:30 PM";
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Scheduled Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Scheduled Time',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kTextPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: sheetContext,
                          initialTime: const TimeOfDay(hour: 8, minute: 0),
                        );
                        if (picked != null) {
                          setModalState(() {
                            final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
                            final minute = picked.minute.toString().padLeft(2, '0');
                            final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
                            scheduledTime = '${hour.toString().padLeft(2, '0')}:$minute $period';
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kbackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Iconsax.clock, size: 16, color: kprimaryColor),
                            const SizedBox(width: 6),
                            Text(
                              scheduledTime,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: kprimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final mealPlanProvider =
                          Provider.of<MealPlanProvider>(context, listen: false);

                      mealPlanProvider.addMeal(
                        PlannedMeal(
                          id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
                          day: selectedDay,
                          mealType: selectedMealType,
                          recipeName: recipeName,
                          time: scheduledTime,
                          calories: calories,
                          imageUrl: imageUrl,
                        ),
                      );

                      Navigator.pop(ctx);

                      final fullDayName =
                          dayNames[days.indexOf(selectedDay)];

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added to $fullDayName ($selectedMealType)!',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: kprimaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          action: SnackBarAction(
                            label: 'VIEW PLAN',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MealPlanScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Confirm & Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    final data = (widget.documentSnapshot?.data() as Map<String, dynamic>?) ?? {};

    final String name = widget.recipe?.name ?? (data['name']?.toString() ?? "Mindful Recipe");
    String itemId = widget.recipe?.id ?? (data['id']?.toString() ?? widget.documentSnapshot?.id ?? "recipe");
    if (widget.recipe == null && name.isNotEmpty) {
      for (final r in MockDataService.getAllRecipes()) {
        if (r.name.trim().toLowerCase() == name.trim().toLowerCase()) {
          itemId = r.id;
          break;
        }
      }
    }
    final String image = widget.recipe?.image ?? (data['image']?.toString() ?? "");
    final String cal = widget.recipe?.cal ?? (data['cal']?.toString() ?? "250");
    final String time = widget.recipe?.time ?? (data['time']?.toString() ?? "20");
    final String rate = widget.recipe?.rate ?? (data['rate']?.toString() ?? "4.9");
    final String reviews = widget.recipe?.reviews ?? (data['reviews']?.toString() ?? "48");
    final String category = widget.recipe?.category ?? (data['category']?.toString() ?? "Mindful Bowls");
    final String description = widget.recipe?.description ??
        (data['description']?.toString() ??
            "A thoughtfully prepared mindful dish packed with wholesome, natural ingredients to nurture body and soul.");

    final rawNames = widget.recipe?.ingredientsName ?? data['ingredientsName'];
    final List<String> ingredientNames = rawNames is List
        ? rawNames.map((e) => e.toString()).toList()
        : ["Organic Ingredient", "Fresh Seasoning", "Cold-Pressed Oil"];

    final rawImages = widget.recipe?.ingredientsImage ?? data['ingredientsImage'];
    final List<String> ingredientImages = rawImages is List
        ? rawImages.map((e) => e.toString()).toList()
        : [];

    final scaledAmounts = quantityProvider.updateIngredientAmounts;
    final bool isFav = favProvider.isFavorite(itemId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Image Header App Bar
          SliverAppBar(
            expandedHeight: 310,
            pinned: true,
            backgroundColor: kbackgroundColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Center(
                child: MyIconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: kTextPrimaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Center(
                  child: MyIconButton(
                    icon: Icon(
                      isFav ? Iconsax.heart5 : Iconsax.heart,
                      color: isFav ? kBannerColor : kTextPrimaryColor,
                      size: 20,
                    ),
                    onPressed: () => favProvider.toggleFavorite(itemId),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'recipe_image_$itemId',
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: kCardBgColor,
                          child: const Center(
                            child: Icon(Iconsax.image, size: 60, color: kTextSecondaryColor),
                          ),
                        ),
                      )
                    : Container(
                        color: kCardBgColor,
                        child: const Center(
                          child: Icon(Iconsax.image, size: 60, color: kTextSecondaryColor),
                        ),
                      ),
              ),
            ),
          ),

          // Recipe Details Body
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kprimaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kprimaryColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            rate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kTextPrimaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviews reviews)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kTextSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Recipe Title
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nutrition & Servings Info Row
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kbackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Iconsax.flash_1,
                          value: '$cal Cal',
                          label: 'Energy',
                          color: kBannerColor,
                        ),
                        Container(width: 1, height: 35, color: kBorderColor),
                        _buildStatItem(
                          icon: Iconsax.clock,
                          value: '$time Min',
                          label: 'Cooking Time',
                          color: kprimaryColor,
                        ),
                        Container(width: 1, height: 35, color: kBorderColor),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Servings',
                              style: TextStyle(fontSize: 11, color: kTextSecondaryColor),
                            ),
                            const SizedBox(height: 4),
                            QuantityIncrementDecrement(
                              currentNumber: quantityProvider.currentNumber,
                              onAdd: quantityProvider.increaseQuantity,
                              onRemov: quantityProvider.decreaseQuantity,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About this recipe',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kTextSecondaryColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimaryColor,
                        ),
                      ),
                      Text(
                        '${ingredientNames.length} items',
                        style: const TextStyle(
                          fontSize: 13,
                          color: kTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Dynamic Scaled Ingredients List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ingredientNames.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final ingName = ingredientNames[index];
                      final ingAmount = index < scaledAmounts.length ? scaledAmounts[index] : "50";
                      final ingImg = index < ingredientImages.length ? ingredientImages[index] : "";

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: kbackgroundColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kBorderColor.withValues(alpha: 0.8)),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ingImg.isNotEmpty
                                  ? Image.network(
                                      ingImg,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderIngImage(),
                                    )
                                  : _buildPlaceholderIngImage(),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                ingName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: kTextPrimaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$ingAmount g',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: kprimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Bottom Action CTA
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showScheduleModal(
                          context: context,
                          recipeName: name,
                          calories: '$cal Cal',
                          imageUrl: image,
                        );
                      },
                      icon: const Icon(Iconsax.calendar_add, color: Colors.white, size: 20),
                      label: const Text(
                        'Add to Meal Planner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kTextPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: kTextSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIngImage() {
    return Container(
      width: 44,
      height: 44,
      color: kCardBgColor,
      child: const Icon(Iconsax.box, size: 22, color: kTextSecondaryColor),
    );
  }
}
