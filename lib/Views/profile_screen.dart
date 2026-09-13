import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/auth_provider.dart';
import '../Utils/constants.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _cookingReminders = true;
  bool _vegetarianOption = true;
  bool _glutenFreeOption = false;
  bool _highProteinOption = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _cookingReminders = prefs.getBool('pref_cooking_reminders') ?? true;
        _vegetarianOption = prefs.getBool('pref_vegetarian') ?? true;
        _glutenFreeOption = prefs.getBool('pref_gluten_free') ?? false;
        _highProteinOption = prefs.getBool('pref_high_protein') ?? true;
      });
    }
  }

  Future<void> _updatePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AppAuthProvider>(context);
    final user = auth.currentUser;
    final displayName = user?.displayName ?? 'Chef Mehjabin';
    final email = user?.email ?? (user?.isGuest == true ? 'Guest Session' : 'mehjabin@mindfulrecipes.com');

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            // User Avatar & Name Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: kprimaryColor.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: kprimaryColor.withValues(alpha: 0.15),
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kprimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kTextPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kTextSecondaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user?.isGuest == true) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: kBannerColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Guest Mode',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: kBannerColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.edit, color: kprimaryColor, size: 20),
                    onPressed: () => _showEditNameDialog(context, auth, displayName),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Preferences Group
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 10),
            _buildSettingCard(
              children: [
                _buildSettingTile(
                  icon: Iconsax.heart,
                  title: 'Dietary Preferences',
                  subtitle: 'Vegetarian, Gluten-Free, High Protein',
                  onTap: () => _showDietaryDialog(context),
                ),
                const Divider(height: 1, color: kBorderColor),
                _buildSettingTile(
                  icon: Iconsax.notification,
                  title: 'Cooking Reminders',
                  subtitle: 'Daily meal prep alerts',
                  trailing: Switch(
                    value: _cookingReminders,
                    activeThumbColor: kprimaryColor,
                    activeTrackColor: kprimaryColor.withValues(alpha: 0.3),
                    onChanged: (val) {
                      setState(() => _cookingReminders = val);
                      _updatePref('pref_cooking_reminders', val);
                    },
                  ),
                ),
                const Divider(height: 1, color: kBorderColor),
                _buildSettingTile(
                  icon: Iconsax.notification_bing,
                  title: 'View Notifications Inbox',
                  subtitle: 'Daily habit & prep reminders',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Account & Info'),
            const SizedBox(height: 10),
            _buildSettingCard(
              children: [
                _buildSettingTile(
                  icon: Iconsax.info_circle,
                  title: 'About Mindful Recipes',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1, color: kBorderColor),
                _buildSettingTile(
                  icon: Iconsax.logout,
                  title: 'Sign Out',
                  titleColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('Sign Out'),
                        content: const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await auth.signOut();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: kTextSecondaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kprimaryColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  static Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? kprimaryColor).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? kprimaryColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: titleColor ?? kTextPrimaryColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12, color: kTextSecondaryColor))
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: kTextSecondaryColor),
      onTap: onTap,
    );
  }

  void _showEditNameDialog(BuildContext context, AppAuthProvider auth, String current) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Display Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              auth.updateDisplayName(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDietaryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Dietary Preferences'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                value: _vegetarianOption,
                activeColor: kprimaryColor,
                title: const Text('Vegetarian Options'),
                onChanged: (val) {
                  final v = val ?? true;
                  setState(() => _vegetarianOption = v);
                  setModalState(() => _vegetarianOption = v);
                  _updatePref('pref_vegetarian', v);
                },
              ),
              CheckboxListTile(
                value: _glutenFreeOption,
                activeColor: kprimaryColor,
                title: const Text('Gluten-Free Only'),
                onChanged: (val) {
                  final v = val ?? false;
                  setState(() => _glutenFreeOption = v);
                  setModalState(() => _glutenFreeOption = v);
                  _updatePref('pref_gluten_free', v);
                },
              ),
              CheckboxListTile(
                value: _highProteinOption,
                activeColor: kprimaryColor,
                title: const Text('High Protein Focus'),
                onChanged: (val) {
                  final v = val ?? true;
                  setState(() => _highProteinOption = v);
                  setModalState(() => _highProteinOption = v);
                  _updatePref('pref_high_protein', v);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Mindful Recipes'),
        content: const Text(
          'Crafted with serene designs and healthy culinary recipes to bring peace and joy to your kitchen.\n\nAuthor: Mehjabin\nVersion: 1.0.0',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
