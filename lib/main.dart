import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/auth_provider.dart';
import 'Provider/favorite_provider.dart';
import 'Provider/meal_plan_provider.dart';
import 'Provider/quantity.dart';
import 'Utils/theme.dart';
import 'Views/auth_gate.dart';
import 'services/mock_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimized image cache configuration
  PaintingBinding.instance.imageCache.maximumSize = 300;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100MB

  // Initialize offline recipe catalog immediately
  await MockDataService.init();

  runApp(const RecipeApp());

  // Non-blocking background Firestore seeder (if Firebase is configured)
  MockDataService.seedFirestoreIfEmpty();
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
      child: MaterialApp(
        title: 'Recipe App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}
