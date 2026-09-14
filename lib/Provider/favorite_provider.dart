import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  String? _activeUid;

  List<String> get favorites => List.unmodifiable(_favoriteIds);

  String get currentUid {
    if (_activeUid != null && _activeUid!.isNotEmpty) {
      return _activeUid!;
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous) {
        return user.uid;
      }
    } catch (_) {}
    return 'guest';
  }

  FavoriteProvider() {
    _initFavorites();
    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseAuth.instance.authStateChanges().listen((user) {
          checkUserChanged(user?.uid);
        });
      }
    } catch (_) {}
  }

  void checkUserChanged(String? newUid) {
    final target = (newUid != null && newUid.isNotEmpty) ? newUid : 'guest';
    if (_activeUid != target) {
      _activeUid = target;
      _initFavorites();
    }
  }

  Future<void> _initFavorites() async {
    await _loadFromPrefs();
    await _syncFromCloud();
  }

  String _getStorageKey() => 'saved_favorites_$currentUid';

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_activeUid == null || _activeUid == 'guest') {
        final savedUid = prefs.getString('saved_uid');
        if (savedUid != null && savedUid.isNotEmpty) {
          _activeUid = savedUid;
        }
      }
      final saved = prefs.getStringList(_getStorageKey());
      final loaded = saved != null ? List<String>.from(saved) : <String>[];
      for (final id in _favoriteIds) {
        if (!loaded.contains(id)) {
          loaded.add(id);
        }
      }
      _favoriteIds = loaded;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading favorites from prefs: $e");
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_getStorageKey(), _favoriteIds);
    } catch (e) {
      debugPrint("Error saving favorites to prefs: $e");
    }
  }

  Future<void> _syncFromCloud() async {
    try {
      if (Firebase.apps.isNotEmpty && currentUid != 'guest') {
        final doc = await FirebaseFirestore.instance.collection('user_favorites').doc(currentUid).get();
        if (doc.exists) {
          final data = doc.data();
          final cloudFavorites = List<String>.from(data?['favorites'] ?? []);
          if (cloudFavorites.isNotEmpty) {
            _favoriteIds = cloudFavorites;
            await _saveToPrefs();
            notifyListeners();
          }
        }
      }
    } catch (_) {}
  }

  bool isFavorite(String recipeId) {
    return _favoriteIds.contains(recipeId);
  }

  void toggleFavorite(String recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();

    // Persist immediately locally
    _saveToPrefs();

    // Background sync to Firestore
    _syncFavoriteToCloud(recipeId);
  }

  Future<void> _syncFavoriteToCloud(String recipeId) async {
    try {
      if (Firebase.apps.isNotEmpty && currentUid != 'guest') {
        await FirebaseFirestore.instance.collection('user_favorites').doc(currentUid).set({
          'favorites': _favoriteIds,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (_) {}
  }
}
