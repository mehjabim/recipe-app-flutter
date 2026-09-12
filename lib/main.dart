import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/auth_provider.dart';
import 'Utils/theme.dart';
import 'Views/auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimized image cache configuration
  PaintingBinding.instance.imageCache.maximumSize = 300;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100MB

  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
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
