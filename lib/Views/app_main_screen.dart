import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../Utils/constants.dart';
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
      const _PlaceholderView(
        title: 'Meal Planner',
        subtitle: 'Plan your weekly mindful dishes. Scheduled for Part 6.',
        icon: Iconsax.calendar_1,
      ),
      const _PlaceholderView(
        title: 'Saved Favorites',
        subtitle: 'Your personal bookmarked recipes will appear here. Scheduled for Part 6.',
        icon: Iconsax.heart,
      ),
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

class _PlaceholderView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PlaceholderView({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: kprimaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 44, color: kprimaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: kTextSecondaryColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
