import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import '../Utils/constants.dart';
import '../Widget/banner.dart';
import '../Widget/food_items_display.dart';
import '../Widget/my_icon_button.dart';
import '../services/mock_data_service.dart';

class MyAppHomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const MyAppHomeScreen({super.key, this.onNavigateTab});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String _selectedCategory = "All";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AppAuthProvider>(context);
    final userName = auth.currentUser?.displayName ?? "Chef Mehjabin";

    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $userName 👋',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'What mindful dish shall we make?',
                        style: TextStyle(
                          fontSize: 14,
                          color: kTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  MyIconButton(
                    icon: const Icon(Iconsax.notification, color: kTextPrimaryColor, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('No new notifications right now.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: kprimaryColor.withValues(alpha: 0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search ingredients, recipes...',
                    prefixIcon: const Icon(Iconsax.search_normal_1, color: kprimaryColor, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: kTextSecondaryColor),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Promotional / Exploration Banner
              BannerWidget(
                onExplore: () {
                  setState(() {
                    _selectedCategory = "Mindful Bowls";
                  });
                },
              ),
              const SizedBox(height: 24),

              // Categories Header
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),

              // Category Selector Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: MockDataService.defaultCategories.map((cat) {
                    final catName = cat['name'] as String;
                    final isSelected = _selectedCategory == catName;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = catName;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? kBannerColor : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: kBannerColor.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              else
                                BoxShadow(
                                  color: kprimaryColor.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Text(
                            catName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : kTextSecondaryColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Recipes Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mindful Recipes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(2); // Go to Favorites
                      }
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: kprimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recipes Horizontal List
              _buildRecipeList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    // Check if Firebase is active
    if (Firebase.apps.isNotEmpty) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final cat = data['category']?.toString() ?? "";
              final name = data['name']?.toString().toLowerCase() ?? "";

              final matchesCategory = _selectedCategory == "All" ||
                  cat.toLowerCase() == _selectedCategory.toLowerCase();
              final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery);

              return matchesCategory && matchesSearch;
            }).toList();

            if (docs.isEmpty) {
              return _buildEmptyState();
            }

            return SizedBox(
              height: 255,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return FoodItemsDisplay(
                    documentSnapshot: docs[index],
                    onTap: () => _openRecipePlaceholder(docs[index].id, docs[index]['name']),
                  );
                },
              ),
            );
          }
          return _buildMockRecipeList();
        },
      );
    }

    return _buildMockRecipeList();
  }

  Widget _buildMockRecipeList() {
    final recipes = MockDataService.getRecipesByCategory(_selectedCategory).where((r) {
      if (_searchQuery.isEmpty) return true;
      return r.name.toLowerCase().contains(_searchQuery);
    }).toList();

    if (recipes.isEmpty) {
      return _buildEmptyState();
    }

    return SizedBox(
      height: 255,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return FoodItemsDisplay(
            recipe: recipes[index],
            onTap: () => _openRecipePlaceholder(recipes[index].id, recipes[index].name),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          Icon(Iconsax.search_status, size: 48, color: kTextSecondaryColor.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          const Text(
            'No recipes found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kTextPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try switching categories or using different keywords',
            style: TextStyle(fontSize: 13, color: kTextSecondaryColor),
          ),
        ],
      ),
    );
  }

  void _openRecipePlaceholder(String id, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected "$name". Detail view coming in Part 5!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
