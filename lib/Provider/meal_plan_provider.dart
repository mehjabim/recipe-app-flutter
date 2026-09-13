import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlannedMeal {
  final String id;
  final String day; // Mon, Tue, Wed, Thu, Fri, Sat, Sun
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final String recipeName;
  final String time;
  final String calories;
  final String imageUrl;
  final bool isCompleted;

  PlannedMeal({
    required this.id,
    required this.day,
    required this.mealType,
    required this.recipeName,
    required this.time,
    required this.calories,
    required this.imageUrl,
    this.isCompleted = false,
  });

  PlannedMeal copyWith({
    String? id,
    String? day,
    String? mealType,
    String? recipeName,
    String? time,
    String? calories,
    String? imageUrl,
    bool? isCompleted,
  }) {
    return PlannedMeal(
      id: id ?? this.id,
      day: day ?? this.day,
      mealType: mealType ?? this.mealType,
      recipeName: recipeName ?? this.recipeName,
      time: time ?? this.time,
      calories: calories ?? this.calories,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'mealType': mealType,
      'recipeName': recipeName,
      'time': time,
      'calories': calories,
      'imageUrl': imageUrl,
      'isCompleted': isCompleted,
    };
  }

  factory PlannedMeal.fromJson(Map<String, dynamic> data) {
    return PlannedMeal(
      id: data['id'] ?? 'meal_${DateTime.now().millisecondsSinceEpoch}',
      day: data['day'] ?? 'Mon',
      mealType: data['mealType'] ?? 'Breakfast',
      recipeName: data['recipeName'] ?? 'Mindful Recipe',
      time: data['time'] ?? '08:00 AM',
      calories: data['calories'] ?? '250 Cal',
      imageUrl: data['imageUrl'] ??
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80',
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}

class MealPlanProvider extends ChangeNotifier {
  List<PlannedMeal> _meals = [];
  String? _activeUid;

  List<PlannedMeal> get meals => _meals;

  String get currentUid {
    if (_activeUid != null && _activeUid!.isNotEmpty) return _activeUid!;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous) return user.uid;
    } catch (_) {}
    return 'guest';
  }

  MealPlanProvider() {
    _initMealPlan();
    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseAuth.instance.authStateChanges().listen((user) {
          checkUserChanged(user?.uid);
        });
      }
    } catch (_) {}
  }

  void checkUserChanged(String? newUid) {
    final target = newUid ?? 'guest';
    if (_activeUid != target) {
      _activeUid = target;
      _initMealPlan();
    }
  }

  String _getStorageKey() => 'saved_meal_plan_$currentUid';

  Future<void> _initMealPlan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_getStorageKey());
      if (saved != null && saved.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(saved);
        _meals = decoded.map((m) => PlannedMeal.fromJson(m)).toList();
      } else {
        _meals = _getInitialDefaultPlan();
        await _saveToPrefs();
      }
      notifyListeners();
      await _syncFromCloud();
    } catch (e) {
      debugPrint("MealPlanProvider init error: $e");
      _meals = _getInitialDefaultPlan();
      notifyListeners();
    }
  }

  List<PlannedMeal> _getInitialDefaultPlan() {
    return [
      PlannedMeal(
        id: 'default_1',
        day: 'Mon',
        mealType: 'Breakfast',
        recipeName: 'Berry Lavender Chia Pudding',
        time: '08:00 AM',
        calories: '260 Cal',
        imageUrl:
            'https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=600&q=80',
        isCompleted: false,
      ),
      PlannedMeal(
        id: 'default_2',
        day: 'Mon',
        mealType: 'Lunch',
        recipeName: 'Rainbow Quinoa Glow Bowl',
        time: '01:00 PM',
        calories: '420 Cal',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
        isCompleted: false,
      ),
      PlannedMeal(
        id: 'default_3',
        day: 'Tue',
        mealType: 'Breakfast',
        recipeName: 'Avocado & Poached Egg Tartine',
        time: '08:30 AM',
        calories: '290 Cal',
        imageUrl:
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80',
        isCompleted: false,
      ),
      PlannedMeal(
        id: 'default_4',
        day: 'Wed',
        mealType: 'Dinner',
        recipeName: 'Creamy Butternut Squash Soup',
        time: '07:30 PM',
        calories: '240 Cal',
        imageUrl:
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=600&q=80',
        isCompleted: false,
      ),
    ];
  }

  List<PlannedMeal> getMealsForDay(String day) {
    return _meals.where((m) => m.day == day).toList();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_meals.map((m) => m.toJson()).toList());
      await prefs.setString(_getStorageKey(), jsonStr);
    } catch (_) {}
  }

  void toggleMealCompletion(String mealId) {
    final index = _meals.indexWhere((m) => m.id == mealId);
    if (index != -1) {
      _meals[index] = _meals[index].copyWith(
        isCompleted: !_meals[index].isCompleted,
      );
      notifyListeners();
      _saveToPrefs();
      _syncToCloud();
    }
  }

  void addMeal(PlannedMeal meal) {
    _meals.add(meal);
    notifyListeners();
    _saveToPrefs();
    _syncToCloud();
  }

  PlannedMeal removeMeal(String mealId) {
    final index = _meals.indexWhere((m) => m.id == mealId);
    if (index != -1) {
      final removed = _meals.removeAt(index);
      notifyListeners();
      _saveToPrefs();
      _syncToCloud();
      return removed;
    }
    throw Exception('Meal not found');
  }

  void restoreMeal(PlannedMeal meal) {
    _meals.add(meal);
    notifyListeners();
    _saveToPrefs();
    _syncToCloud();
  }

  Future<void> _syncToCloud() async {
    try {
      if (Firebase.apps.isNotEmpty && currentUid != 'guest') {
        final collection = FirebaseFirestore.instance
            .collection('user_meal_plans')
            .doc(currentUid);
        await collection.set({
          'meals': _meals.map((m) => m.toJson()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  Future<void> _syncFromCloud() async {
    try {
      if (Firebase.apps.isNotEmpty && currentUid != 'guest') {
        final doc = await FirebaseFirestore.instance
            .collection('user_meal_plans')
            .doc(currentUid)
            .get();
        if (doc.exists) {
          final raw = doc.data()?['meals'] as List<dynamic>?;
          if (raw != null && raw.isNotEmpty) {
            _meals = raw.map((m) => PlannedMeal.fromJson(m)).toList();
            await _saveToPrefs();
            notifyListeners();
          }
        }
      }
    } catch (_) {}
  }
}
