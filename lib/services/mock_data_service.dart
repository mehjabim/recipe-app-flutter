import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

class MockDataService {
  static final List<Map<String, dynamic>> defaultCategories = [
    {"name": "All"},
    {"name": "Mindful Bowls"},
    {"name": "Energizing Breakfast"},
    {"name": "Fresh Greens"},
    {"name": "Warm Comfort"},
    {"name": "Sweet Treats"},
    {"name": "Quick Snacks"},
  ];

  static final List<Map<String, dynamic>> defaultRecipes = [
    // --- MINDFUL BOWLS ---
    {
      "name": "Roasted Sweet Potato Buddha Bowl",
      "image": "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=600&q=80",
      "cal": "380",
      "time": "30",
      "rate": "4.9",
      "reviews": "112",
      "category": "Mindful Bowls",
      "description": "Caramelized paprika sweet potato cubes, tender steamed kale, marinated chickpeas, and organic hemp seeds topped with a creamy maple tahini sauce.",
      "ingredientsAmount": [200.0, 100.0, 150.0, 30.0],
      "ingredientsName": ["Sweet Potatoes", "Fresh Kale", "Chickpeas", "Maple Tahini"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1524179091875-bf99a9a6fa57?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Sesame Soba Noodle Glow Bowl",
      "image": "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80",
      "cal": "350",
      "time": "20",
      "rate": "4.8",
      "reviews": "84",
      "category": "Mindful Bowls",
      "description": "Chilled Japanese buckwheat noodles tossed with toasted sesame oil, crisp shredded radishes, edamame, and a light ponzu vinaigrette.",
      "ingredientsAmount": [180.0, 80.0, 60.0, 25.0],
      "ingredientsName": ["Soba Noodles", "Edamame", "Watermelon Radish", "Sesame Ponzu"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- ENERGIZING BREAKFAST ---
    {
      "name": "Purple Acai Radiance Bowl",
      "image": "https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&w=600&q=80",
      "cal": "290",
      "time": "10",
      "rate": "4.9",
      "reviews": "145",
      "category": "Energizing Breakfast",
      "description": "Thick frozen organic acai blended with frozen blueberries and banana, topped with shaved raw coconut, chia seeds, and artisan granola.",
      "ingredientsAmount": [150.0, 100.0, 40.0, 20.0],
      "ingredientsName": ["Wild Acai Berry", "Frozen Bananas", "Oat Granola", "Coconut Ribbons"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Matcha Coconut Chia Jar",
      "image": "https://images.unsplash.com/photo-1536256263959-770b48d82b0a?auto=format&fit=crop&w=600&q=80",
      "cal": "240",
      "time": "12",
      "rate": "4.8",
      "reviews": "62",
      "category": "Energizing Breakfast",
      "description": "Ceremonial Uji matcha infused with creamy coconut milk and soaked chia seeds, finished with kiwi slices and roasted pistachios.",
      "ingredientsAmount": [15.0, 200.0, 40.0, 25.0],
      "ingredientsName": ["Ceremonial Matcha", "Coconut Milk", "Chia Seeds", "Pistachios"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Wild Blueberry Lemon Ricotta Toast",
      "image": "https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=600&q=80",
      "cal": "310",
      "time": "15",
      "rate": "4.7",
      "reviews": "51",
      "category": "Energizing Breakfast",
      "description": "Toasted multi-grain brioche smothered in whipped lemon zest ricotta and warm blueberry compote with fresh mint sprigs.",
      "ingredientsAmount": [120.0, 80.0, 90.0, 5.0],
      "ingredientsName": ["Multi-grain Brioche", "Whipped Ricotta", "Wild Blueberries", "Fresh Mint"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- FRESH GREENS ---
    {
      "name": "Crisp Pear & Walnut Arugula Salad",
      "image": "https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?auto=format&fit=crop&w=600&q=80",
      "cal": "270",
      "time": "15",
      "rate": "4.8",
      "reviews": "78",
      "category": "Fresh Greens",
      "description": "Peppery wild baby arugula, thinly shaved Bosc pear, toasted golden walnuts, and aged balsamic reduction with goat cheese crumbles.",
      "ingredientsAmount": [100.0, 120.0, 40.0, 50.0],
      "ingredientsName": ["Baby Arugula", "Bosc Pear", "Toasted Walnuts", "Aged Balsamic"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Citrus Fennel Superfood Salad",
      "image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80",
      "cal": "220",
      "time": "14",
      "rate": "4.7",
      "reviews": "43",
      "category": "Fresh Greens",
      "description": "Shaved Florence fennel, ruby grapefruit segments, avocado, and pomegranate arils tossed in citrus-infused extra virgin olive oil.",
      "ingredientsAmount": [120.0, 100.0, 90.0, 30.0],
      "ingredientsName": ["Florence Fennel", "Ruby Grapefruit", "Ripe Avocado", "Pomegranate Seeds"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- WARM COMFORT ---
    {
      "name": "Golden Turmeric Ginger Lentil Dal",
      "image": "https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=600&q=80",
      "cal": "360",
      "time": "35",
      "rate": "4.9",
      "reviews": "130",
      "category": "Warm Comfort",
      "description": "Slow-simmered red lentils infused with fragrant organic turmeric, grated ginger, cumin, and rich coconut milk garnished with fresh coriander.",
      "ingredientsAmount": [200.0, 15.0, 150.0, 10.0],
      "ingredientsName": ["Red Split Lentils", "Fresh Ginger & Turmeric", "Coconut Milk", "Cilantro"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Creamy Coconut Lime Tom Kha",
      "image": "https://images.unsplash.com/photo-1548943487-a2e4e43b4853?auto=format&fit=crop&w=600&q=80",
      "cal": "310",
      "time": "25",
      "rate": "4.8",
      "reviews": "95",
      "category": "Warm Comfort",
      "description": "Soothing aromatic coconut soup simmered with lemongrass stalk, galangal, straw mushrooms, and freshly squeezed kaffir lime juice.",
      "ingredientsAmount": [250.0, 20.0, 100.0, 15.0],
      "ingredientsName": ["Rich Coconut Milk", "Lemongrass & Galangal", "Straw Mushrooms", "Lime Juice"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- SWEET TREATS ---
    {
      "name": "Lavender Infused French Crepes",
      "image": "https://images.unsplash.com/photo-1519676867240-f03562e64548?auto=format&fit=crop&w=600&q=80",
      "cal": "250",
      "time": "20",
      "rate": "4.9",
      "reviews": "119",
      "category": "Sweet Treats",
      "description": "Delicate golden paper-thin French crepes infused with lavender flower essence, folded with Greek yogurt and wildflower honey.",
      "ingredientsAmount": [120.0, 150.0, 100.0, 25.0],
      "ingredientsName": ["Spelt Flour", "Almond Milk", "Greek Yogurt", "Wildflower Honey"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=120&q=60",
      ],
    },
    {
      "name": "Raw Raspberry Lavender Tartlet",
      "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80",
      "cal": "210",
      "time": "15",
      "rate": "4.9",
      "reviews": "82",
      "category": "Sweet Treats",
      "description": "No-bake almond date crust packed with cashew vanilla cream, fresh raspberries, and a delicate lavender glaze.",
      "ingredientsAmount": [90.0, 100.0, 80.0, 15.0],
      "ingredientsName": ["Raw Almonds & Dates", "Soaked Cashews", "Fresh Raspberries", "Lavender Essence"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
      ],
    },

    // --- QUICK SNACKS ---
    {
      "name": "Crispy Baked Herb Falafel",
      "image": "https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?auto=format&fit=crop&w=600&q=80",
      "cal": "190",
      "time": "20",
      "rate": "4.8",
      "reviews": "64",
      "category": "Quick Snacks",
      "description": "Oven-baked Mediterranean falafel patties blended with fresh parsley, cilantro, garlic, cumin, and served with cucumber tzatziki.",
      "ingredientsAmount": [160.0, 30.0, 15.0, 40.0],
      "ingredientsName": ["Chickpeas", "Fresh Parsley & Coriander", "Cumin & Garlic", "Cucumber Tzatziki"],
      "ingredientsImage": [
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=120&q=60",
        "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=120&q=60",
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
        return RecipeModel.fromMap(entry.value, "mindful_recipe_${entry.key + 1}");
      }).toList();

      _cachedRecipes = [...customRecipes, ...defaultList];
    } catch (e) {
      debugPrint("MockDataService init error: $e");
      _cachedRecipes = defaultRecipes.asMap().entries.map((entry) {
        return RecipeModel.fromMap(entry.value, "mindful_recipe_${entry.key + 1}");
      }).toList();
    }
  }

  static List<RecipeModel> getAllRecipes() {
    if (_cachedRecipes.isEmpty) {
      _cachedRecipes = defaultRecipes.asMap().entries.map((entry) {
        return RecipeModel.fromMap(entry.value, "mindful_recipe_${entry.key + 1}");
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
        debugPrint("Seeding mindful recipes to Firestore in background...");
        final batch = FirebaseFirestore.instance.batch();
        for (var recipe in defaultRecipes) {
          final doc = recipesRef.doc();
          batch.set(doc, recipe);
        }
        await batch.commit();
        debugPrint("Mindful recipes seeded successfully!");
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
