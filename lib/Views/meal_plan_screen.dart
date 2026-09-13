import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../Provider/meal_plan_provider.dart';
import '../Utils/constants.dart';
import '../models/recipe_model.dart';
import '../services/mock_data_service.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDayIndex = 0;
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<String> _fullDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealPlanProvider>(context);
    final currentDay = _days[_selectedDayIndex];
    final dayMeals = mealProvider.getMealsForDay(currentDay);
    final completedCount = dayMeals.where((m) => m.isCompleted).length;

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle, color: kprimaryColor, size: 26),
            onPressed: () => _showAddMealDialog(context, currentDay),
          ),
        ],
      ),
      body: Column(
        children: [
          // Days Horizontal Selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: List.generate(_days.length, (index) {
                  final isSelected = _selectedDayIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? kprimaryColor : kbackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: kprimaryColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Text(
                          _days[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : kTextSecondaryColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Day Progress Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _fullDays[_selectedDayIndex],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kBannerColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$completedCount of ${dayMeals.length} done',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: kBannerColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Meals List for selected day
          Expanded(
            child: dayMeals.isEmpty
                ? _buildEmptyDayState(currentDay)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                    itemCount: dayMeals.length,
                    itemBuilder: (context, index) {
                      final meal = dayMeals[index];
                      return _buildMealCard(context, mealProvider, meal);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, MealPlanProvider provider, PlannedMeal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kprimaryColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: () => provider.toggleMealCompletion(meal.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: meal.isCompleted ? kprimaryColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: meal.isCompleted ? kprimaryColor : kBorderColor,
                width: 2,
              ),
            ),
            child: meal.isCompleted
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          meal.recipeName,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: meal.isCompleted ? kTextSecondaryColor : kTextPrimaryColor,
            decoration: meal.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kprimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  meal.mealType,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: kprimaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${meal.time} • ${meal.calories}',
                style: const TextStyle(fontSize: 12, color: kTextSecondaryColor),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Iconsax.trash, size: 18, color: Colors.redAccent),
          onPressed: () => _confirmDeleteMeal(context, provider, meal),
        ),
      ),
    );
  }

  Widget _buildEmptyDayState(String day) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kprimaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.calendar_tick, size: 40, color: kprimaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'No meals planned for $day',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kTextPrimaryColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add nourishing dishes to stay consistent with your cooking goals.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kTextSecondaryColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddMealDialog(context, day),
              icon: const Icon(Iconsax.add, size: 18),
              label: const Text('Schedule a Meal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteMeal(BuildContext context, MealPlanProvider provider, PlannedMeal meal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Meal'),
        content: Text('Remove "${meal.recipeName}" from ${meal.day}\'s plan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final removed = provider.removeMeal(meal.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed "${meal.recipeName}"'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: kBannerColor,
                    onPressed: () => provider.restoreMeal(removed),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog(BuildContext context, String currentDay) {
    final recipes = MockDataService.getAllRecipes();
    RecipeModel selectedRecipe = recipes.first;
    String selectedType = "Breakfast";
    final List<String> types = ["Breakfast", "Lunch", "Dinner", "Snack"];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Schedule Meal for $currentDay'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Recipe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<RecipeModel>(
                initialValue: selectedRecipe,
                isExpanded: true,
                items: recipes.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r.name, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedRecipe = val);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Meal Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedType = val);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<MealPlanProvider>(context, listen: false);
                provider.addMeal(
                  PlannedMeal(
                    id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
                    day: currentDay,
                    mealType: selectedType,
                    recipeName: selectedRecipe.name,
                    time: selectedType == 'Breakfast' ? '08:00 AM' : (selectedType == 'Lunch' ? '01:00 PM' : '07:30 PM'),
                    calories: '${selectedRecipe.cal} Cal',
                    imageUrl: selectedRecipe.image,
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${selectedRecipe.name}" to $currentDay!'),
                    backgroundColor: kprimaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
