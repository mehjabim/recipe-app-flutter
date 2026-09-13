import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app3/Provider/auth_provider.dart';
import 'package:recipe_app3/Provider/favorite_provider.dart';
import 'package:recipe_app3/Views/my_app_home_screen.dart';
import 'package:recipe_app3/services/mock_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MyAppHomeScreen renders categories, banner and recipe list', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await MockDataService.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ],
        child: const MaterialApp(
          home: MyAppHomeScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify categories rendered
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Energizing Breakfast'), findsOneWidget);

    // Verify banner rendered
    expect(find.text('Cook with Calm & Joy'), findsOneWidget);

    // Verify recipes section
    expect(find.text('Mindful Recipes'), findsOneWidget);
  });
}
