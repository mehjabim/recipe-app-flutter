import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../Utils/constants.dart';
import 'favorite_screen.dart';
import 'meal_plan_screen.dart';
import 'my_app_home_screen.dart';
import 'profile_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _selectedIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MyAppHomeScreen(onNavigateTab: _navigateToTab),
      const MealPlanScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: kprimaryColor.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            height: 68,
            backgroundColor: Colors.white,
            indicatorColor: kprimaryColor.withValues(alpha: 0.15),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.home, color: kTextSecondaryColor),
                selectedIcon: Icon(Iconsax.home_15, color: kprimaryColor),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.calendar, color: kTextSecondaryColor),
                selectedIcon: Icon(Iconsax.calendar5, color: kprimaryColor),
                label: 'Plan',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.heart, color: kTextSecondaryColor),
                selectedIcon: Icon(Iconsax.heart5, color: kBannerColor),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.user, color: kTextSecondaryColor),
                selectedIcon: Icon(Iconsax.profile_circle5, color: kprimaryColor),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
