import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/auth_provider.dart';
import '../Utils/constants.dart';
import '../Widget/my_icon_button.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String category; // 'reminder', 'tip'
  bool isRead;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'time': time,
        'category': category,
        'isRead': isRead,
      };

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) =>
      AppNotificationItem(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        time: json['time'] as String,
        category: json['category'] as String,
        isRead: json['isRead'] as bool? ?? false,
      );
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = "All";
  List<AppNotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    final uid = auth.currentUser?.uid ?? 'guest';
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('saved_notifications_$uid');

    if (raw != null && raw.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(raw);
      _notifications = decoded.map((e) => AppNotificationItem.fromJson(e)).toList();
    } else {
      _notifications = [
        AppNotificationItem(
          id: 'notif_1',
          title: 'Mindful Morning Habit',
          message: 'Begin your day with hydration and a nutrient-rich breakfast bowl.',
          time: '8:00 AM',
          category: 'tip',
          isRead: false,
        ),
        AppNotificationItem(
          id: 'notif_2',
          title: 'Dinner Prep Scheduled',
          message: 'Your planned meal "Golden Turmeric Ginger Dal" is set for tonight.',
          time: '6:30 PM',
          category: 'reminder',
          isRead: false,
        ),
        AppNotificationItem(
          id: 'notif_3',
          title: 'Seasonal Produce Tip',
          message: 'Crisp apples and squash are peak fresh this week. Explore new bowls!',
          time: 'Yesterday',
          category: 'tip',
          isRead: true,
        ),
      ];
      await _saveNotifications();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final auth = Provider.of<AppAuthProvider>(context, listen: false);
      final uid = auth.currentUser?.uid ?? 'guest';
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_notifications.map((e) => e.toJson()).toList());
      await prefs.setString('saved_notifications_$uid', encoded);
    } catch (_) {}
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
    _saveNotifications();
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
    _saveNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _notifications.where((n) {
      if (_filter == "All") return true;
      return n.category == _filter.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: MyIconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: kTextPrimaryColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty) ...[
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark Read',
                style: TextStyle(color: kprimaryColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.trash, size: 18, color: kTextSecondaryColor),
              onPressed: _clearAll,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kprimaryColor))
          : Column(
              children: [
                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: ["All", "Reminder", "Tip"].map((cat) {
                      final isSelected = _filter == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat == "Reminder" ? "Reminders" : (cat == "Tip" ? "Mindful Tips" : cat)),
                          selected: isSelected,
                          selectedColor: kprimaryColor,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : kTextSecondaryColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _filter = cat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Notifications List
                Expanded(
                  child: filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: kprimaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Iconsax.notification_bing, size: 40, color: kprimaryColor),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No notifications',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextPrimaryColor),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'You are all caught up with your cooking updates.',
                                style: TextStyle(fontSize: 13, color: kTextSecondaryColor),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: item.isRead ? Colors.white.withValues(alpha: 0.8) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: item.isRead
                                    ? Border.all(color: kBorderColor.withValues(alpha: 0.6))
                                    : Border.all(color: kprimaryColor.withValues(alpha: 0.3), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: kprimaryColor.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: item.category == 'reminder'
                                          ? kBannerColor.withValues(alpha: 0.12)
                                          : kprimaryColor.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      item.category == 'reminder' ? Iconsax.clock : Iconsax.lamp_on,
                                      size: 20,
                                      color: item.category == 'reminder' ? kBannerColor : kprimaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                                color: kTextPrimaryColor,
                                              ),
                                            ),
                                            Text(
                                              item.time,
                                              style: const TextStyle(fontSize: 11, color: kTextSecondaryColor),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.message,
                                          style: const TextStyle(fontSize: 13, color: kTextSecondaryColor, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
