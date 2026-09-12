import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

class MockDataService {
  static final List<Map<String, dynamic>> defaultCategories = [
    {"name": "All"},
    {"name": "Breakfast"},
    {"name": "Mindful Bowls"},
    {"name": "Salads"},
    {"name": "Warm Comfort"},
    {"name": "Dessert"},
    {"name": "Quick Bites"},
  ];

  static final List<Map<String, dynamic>> defaultRecipes = [
    // --- BREAKFAST ---
    {
      "name": "Berry Lavender Chia Pudding",
      "image": "https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=600&q=80",
      "cal": "260",
      "time": "15",
      "rate": "4.9",
      "reviews": "92",
      "category": "Breakfast",
      "description": "A calming breakfast bowl layered with organic chia seeds, oat milk, fresh wild berries, and a subtle hint of culinary lavender.",
      "ingredientsAmount": [40.0, 200.0, 80.0, 15.0],
      "ingredientsName": ["Chia Seeds", "Oat Milk", "Fresh Berries", "Pure Honey"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Avocado & Poached Egg Tartine",
      "image": "https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80",
      "cal": "290",
      "time": "12",
      "rate": "4.8",
      "reviews": "74",
      "category": "Breakfast",
      "description": "Crispy artisanal sourdough toast layered with creamy smashed avocado, microgreens, and a velvety soft-poached egg.",
      "ingredientsAmount": [120.0, 150.0, 100.0, 5.0],
      "ingredientsName": ["Artisan Sourdough", "Hass Avocado", "Free-Range Egg", "Red Pepper Flakes"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Golden Banana Cinnamon Oatmeal",
      "image": "https://images.unsplash.com/photo-1517673132405-a56a62b18caf?auto=format&fit=crop&w=600&q=80",
      "cal": "310",
      "time": "10",
      "rate": "4.7",
      "reviews": "58",
      "category": "Breakfast",
      "description": "Warm rolled oats infused with Ceylon cinnamon, topped with caramelized banana medallions, chopped pecans, and maple syrup.",
      "ingredientsAmount": [80.0, 200.0, 100.0, 20.0],
      "ingredientsName": ["Rolled Oats", "Almond Milk", "Ripe Banana", "Crushed Pecans"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- MINDFUL BOWLS ---
    {
      "name": "Rainbow Quinoa Glow Bowl",
      "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80",
      "cal": "420",
      "time": "25",
      "rate": "4.9",
      "reviews": "115",
      "category": "Mindful Bowls",
      "description": "Nutrient-packed fluffy tri-color quinoa surrounded by edamame, shredded purple cabbage, avocado, and tahini lemon dressing.",
      "ingredientsAmount": [150.0, 80.0, 100.0, 30.0],
      "ingredientsName": ["Tri-Color Quinoa", "Edamame", "Purple Cabbage", "Tahini Dressing"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Teriyaki Tofu Harvest Bowl",
      "image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80",
      "cal": "390",
      "time": "20",
      "rate": "4.8",
      "reviews": "88",
      "category": "Mindful Bowls",
      "description": "Crispy pan-seared organic tofu glazed in low-sodium ginger teriyaki served over brown jasmine rice and steamed broccoli florets.",
      "ingredientsAmount": [200.0, 150.0, 100.0, 25.0],
      "ingredientsName": ["Organic Firm Tofu", "Brown Jasmine Rice", "Broccoli Florets", "Ginger Teriyaki"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- SALADS ---
    {
      "name": "Mediterranean Chickpea Crisp",
      "image": "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80",
      "cal": "310",
      "time": "15",
      "rate": "4.8",
      "reviews": "67",
      "category": "Salads",
      "description": "Crisp English cucumbers, cherry tomatoes, kalamata olives, and organic chickpeas tossed in cold-pressed virgin olive oil and oregano.",
      "ingredientsAmount": [180.0, 120.0, 50.0, 30.0],
      "ingredientsName": ["Roasted Chickpeas", "Cherry Tomatoes", "Kalamata Olives", "EVOO & Herbs"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- WARM COMFORT ---
    {
      "name": "Creamy Butternut Squash Soup",
      "image": "https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=600&q=80",
      "cal": "240",
      "time": "30",
      "rate": "4.9",
      "reviews": "104",
      "category": "Warm Comfort",
      "description": "Silky roasted butternut squash simmered with fragrant coconut milk, nutmeg, and topped with toasted pumpkin seeds.",
      "ingredientsAmount": [300.0, 150.0, 20.0, 5.0],
      "ingredientsName": ["Roasted Squash", "Coconut Cream", "Pumpkin Seeds", "Nutmeg & Sage"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- DESSERT ---
    {
      "name": "Dark Chocolate Avocado Mousse",
      "image": "https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80",
      "cal": "220",
      "time": "10",
      "rate": "4.9",
      "reviews": "142",
      "category": "Dessert",
      "description": "Velvety smooth guilt-free mousse made with raw cacao, ripe avocado, pure vanilla bean, and organic maple syrup.",
      "ingredientsAmount": [150.0, 45.0, 30.0, 5.0],
      "ingredientsName": ["Ripe Avocado", "Raw Cacao Powder", "Maple Syrup", "Pure Vanilla Bean"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- QUICK BITES ---
    {
      "name": "Matcha Energy Bliss Bites",
      "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80",
      "cal": "110",
      "time": "15",
      "rate": "4.8",
      "reviews": "53",
      "category": "Quick Bites",
      "description": "No-bake energizing snack bites rolled with ceremonial Japanese matcha, Medjool dates, almonds, and shredded coconut.",
      "ingredientsAmount": [100.0, 100.0, 15.0, 20.0],
      "ingredientsName": ["Medjool Dates", "Raw Almonds", "Ceremonial Matcha", "Coconut Flakes"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
      ],
    },
  ];

  static List<RecipeModel> _cachedRecipes = [];

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customJson = prefs.getString('local_custom_recipes');
      List<RecipeModel> customRecipes = [];
      if (customJson != null) {
        final List<dynamic> decoded = jsonDecode(customJson);
        customRecipes = decoded.map((map) => RecipeModel.fromMap(map, map['id'] ?? 'custom')).toList();
      }

      final defaultList = defaultRecipes.asMap().entries.map((entry) {
        return RecipeModel.fromMap(entry.value, "recipe_${entry.key + 1}");
      }).toList();

      _cachedRecipes = [...customRecipes, ...defaultList];
    } catch (e) {
      debugPrint("MockDataService init error: $e");
      _cachedRecipes = defaultRecipes.asMap().entries.map((entry) {
        return RecipeModel.fromMap(entry.value, "recipe_${entry.key + 1}");
      }).toList();
    }
  }

  static List<RecipeModel> getAllRecipes() {
    if (_cachedRecipes.isEmpty) {
      _cachedRecipes = defaultRecipes.asMap().entries.map((entry) {
        return RecipeModel.fromMap(entry.value, "recipe_${entry.key + 1}");
      }).toList();
    }
    return List.unmodifiable(_cachedRecipes);
  }

  static List<RecipeModel> getRecipesByCategory(String category) {
    final all = getAllRecipes();
    if (category == 'All' || category.trim().isEmpty) return all;
    return all.where((r) => r.category.toLowerCase() == category.toLowerCase()).toList();
  }

  static Future<void> seedFirestoreIfEmpty() async {
    try {
      if (Firebase.apps.isEmpty) return;

      final recipesRef = FirebaseFirestore.instance.collection('recipes');
      final categoriesRef = FirebaseFirestore.instance.collection('categories');

      final recipesSnapshot = await recipesRef.limit(1).get();
      if (recipesSnapshot.docs.isEmpty) {
        debugPrint("Seeding recipes to Firestore in background...");
        final batch = FirebaseFirestore.instance.batch();
        for (var recipe in defaultRecipes) {
          final doc = recipesRef.doc();
          batch.set(doc, recipe);
        }
        await batch.commit();
        debugPrint("Recipes seeded successfully!");
      }

      final categoriesSnapshot = await categoriesRef.limit(1).get();
      if (categoriesSnapshot.docs.isEmpty) {
        debugPrint("Seeding categories to Firestore in background...");
        final batch = FirebaseFirestore.instance.batch();
        for (var cat in defaultCategories) {
          final doc = categoriesRef.doc();
          batch.set(doc, cat);
        }
        await batch.commit();
        debugPrint("Categories seeded successfully!");
      }
    } catch (e) {
      debugPrint("Firestore seeding note: $e");
    }
  }
}
