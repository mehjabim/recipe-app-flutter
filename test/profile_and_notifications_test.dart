import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app3/Provider/auth_provider.dart';
import 'package:recipe_app3/Views/notifications_screen.dart';
import 'package:recipe_app3/Views/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ProfileScreen renders user details, settings and preferences', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Profile & Settings'), findsOneWidget);
    expect(find.text('Dietary Preferences'), findsOneWidget);
    expect(find.text('Cooking Reminders'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('NotificationsScreen renders categories and notification list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ],
        child: const MaterialApp(
          home: NotificationsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Mindful Morning Habit'), findsOneWidget);
  });
}
