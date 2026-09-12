import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final bool isGuest;

  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.isGuest = false,
  });
}

class AppAuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  bool _isInitializing = true;
  String? _errorMessage;
  UserProfile? _guestUser;
  UserProfile? _persistedUser;

  bool get isLoading => _isLoading;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;

  UserProfile? get currentUser => _persistedUser ?? _guestUser;
  bool get isAuthenticated => currentUser != null;

  AppAuthProvider() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (isLoggedIn && _guestUser == null && _persistedUser == null) {
        final uid = prefs.getString('saved_uid') ?? "persisted_user";
        final isGuest = prefs.getBool('is_guest') ?? false;
        final name = prefs.getString('saved_name') ??
            (isGuest ? "Mindful Chef" : "Chef Mehjabin");
        final email = prefs.getString('saved_email');
        final photo = prefs.getString('saved_photo');

        if (isGuest) {
          _guestUser = UserProfile(
            uid: uid,
            displayName: name,
            email: email,
            photoURL: photo,
            isGuest: true,
          );
        } else {
          _persistedUser = UserProfile(
            uid: uid,
            displayName: name,
            email: email,
            photoURL: photo,
            isGuest: false,
          );
        }
      }
    } catch (e) {
      debugPrint("Session restore error: $e");
    }

    _listenToAuth();
    _isInitializing = false;
    notifyListeners();
  }

  void _listenToAuth() {
    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null && !user.isAnonymous) {
            _guestUser = null;
            final derivedName = _deriveDisplayName(user.displayName, user.email, false);
            _persistedUser = UserProfile(
              uid: user.uid,
              displayName: derivedName,
              email: user.email,
              photoURL: user.photoURL,
              isGuest: false,
            );
            _saveSession(
              user.uid,
              derivedName,
              user.email,
              false,
              photo: user.photoURL,
            );
            notifyListeners();
          } else if (user != null && user.isAnonymous) {
            if (_persistedUser == null || _persistedUser!.isGuest) {
              _saveSession(
                user.uid,
                "Mindful Chef",
                "guest@recipeapp.com",
                true,
              );
              notifyListeners();
            }
          }
        });
      }
    } catch (_) {}
  }

  static String _deriveDisplayName(String? name, String? email, bool isAnonymous) {
    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }
    if (isAnonymous) {
      return "Mindful Chef";
    }
    if (email != null && email.isNotEmpty) {
      final prefix = email.split('@').first;
      final formatted = prefix
          .replaceAll(RegExp(r'[._\-]'), ' ')
          .split(' ')
          .where((w) => w.isNotEmpty)
          .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ')
          .trim();
      if (formatted.isNotEmpty) return formatted;
    }
    return "Culinary Explorer";
  }

  Future<void> _saveSession(
    String uid,
    String? name,
    String? email,
    bool isGuest, {
    String? photo,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('saved_uid', uid);
      await prefs.setBool('is_guest', isGuest);
      if (name != null) await prefs.setString('saved_name', name);
      if (email != null) await prefs.setString('saved_email', email);
      if (photo != null) await prefs.setString('saved_photo', photo);
    } catch (_) {}
  }

  Future<bool> signInAsGuest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        try {
          final cred = await FirebaseAuth.instance.signInAnonymously();
          _guestUser = UserProfile(
            uid: cred.user?.uid ?? "guest_${DateTime.now().millisecondsSinceEpoch}",
            displayName: "Mindful Chef",
            email: "guest@recipeapp.com",
            isGuest: true,
          );
        } catch (_) {
          // Local fallback if Firebase anonymous auth is disabled
          _guestUser = UserProfile(
            uid: "guest_${DateTime.now().millisecondsSinceEpoch}",
            displayName: "Mindful Chef",
            email: "guest@recipeapp.com",
            isGuest: true,
          );
        }
      } else {
        _guestUser = UserProfile(
          uid: "guest_${DateTime.now().millisecondsSinceEpoch}",
          displayName: "Mindful Chef",
          email: "guest@recipeapp.com",
          isGuest: true,
        );
      }

      await _saveSession(
        _guestUser!.uid,
        _guestUser!.displayName,
        _guestUser!.email,
        true,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final derivedName = _deriveDisplayName(
          cred.user?.displayName,
          cred.user?.email,
          false,
        );
        _persistedUser = UserProfile(
          uid: cred.user!.uid,
          displayName: derivedName,
          email: cred.user?.email,
          photoURL: cred.user?.photoURL,
          isGuest: false,
        );
        await _saveSession(
          cred.user!.uid,
          derivedName,
          cred.user?.email,
          false,
          photo: cred.user?.photoURL,
        );
      } else {
        // Offline preview mock auth
        final derivedName = _deriveDisplayName(null, email, false);
        _persistedUser = UserProfile(
          uid: "user_${email.hashCode}",
          displayName: derivedName,
          email: email,
          isGuest: false,
        );
        await _saveSession(
          _persistedUser!.uid,
          derivedName,
          email,
          false,
        );
      }

      _guestUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _formatAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        if (name.isNotEmpty) {
          await cred.user?.updateDisplayName(name.trim());
        }
        _persistedUser = UserProfile(
          uid: cred.user!.uid,
          displayName: name.isNotEmpty ? name.trim() : _deriveDisplayName(null, email, false),
          email: cred.user?.email,
          isGuest: false,
        );
        await _saveSession(
          cred.user!.uid,
          _persistedUser!.displayName,
          cred.user?.email,
          false,
        );

        // Save initial user doc to firestore if available
        try {
          await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
            'uid': cred.user!.uid,
            'name': _persistedUser!.displayName,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } catch (_) {}
      } else {
        _persistedUser = UserProfile(
          uid: "user_${email.hashCode}",
          displayName: name.isNotEmpty ? name.trim() : "Mindful Chef",
          email: email,
          isGuest: false,
        );
        await _saveSession(
          _persistedUser!.uid,
          _persistedUser!.displayName,
          email,
          false,
        );
      }

      _guestUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _formatAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (Firebase.apps.isNotEmpty) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final cred = await FirebaseAuth.instance.signInWithCredential(credential);
        final derivedName = _deriveDisplayName(
          cred.user?.displayName,
          cred.user?.email,
          false,
        );
        _persistedUser = UserProfile(
          uid: cred.user!.uid,
          displayName: derivedName,
          email: cred.user?.email,
          photoURL: cred.user?.photoURL,
          isGuest: false,
        );
        await _saveSession(
          cred.user!.uid,
          derivedName,
          cred.user?.email,
          false,
          photo: cred.user?.photoURL,
        );
      } else {
        _persistedUser = UserProfile(
          uid: "google_${googleUser.id}",
          displayName: googleUser.displayName ?? "Google Explorer",
          email: googleUser.email,
          photoURL: googleUser.photoUrl,
          isGuest: false,
        );
        await _saveSession(
          _persistedUser!.uid,
          _persistedUser!.displayName,
          googleUser.email,
          false,
          photo: googleUser.photoUrl,
        );
      }

      _guestUser = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _formatAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateDisplayName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    if (_persistedUser != null) {
      _persistedUser = UserProfile(
        uid: _persistedUser!.uid,
        displayName: trimmed,
        email: _persistedUser!.email,
        photoURL: _persistedUser!.photoURL,
        isGuest: false,
      );
    } else if (_guestUser != null) {
      _guestUser = UserProfile(
        uid: _guestUser!.uid,
        displayName: trimmed,
        email: _guestUser!.email,
        photoURL: _guestUser!.photoURL,
        isGuest: true,
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_name', trimmed);
      if (Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(trimmed);
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseAuth.instance.signOut();
        await _googleSignIn.signOut();
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_logged_in');
      await prefs.remove('saved_uid');
      await prefs.remove('saved_name');
      await prefs.remove('saved_email');
      await prefs.remove('saved_photo');
      await prefs.remove('is_guest');
    } catch (_) {}

    _guestUser = null;
    _persistedUser = null;
    _isLoading = false;
    notifyListeners();
  }

  String _formatAuthError(dynamic e) {
    final str = e.toString().toLowerCase();
    if (str.contains('user-not-found') || str.contains('invalid-credential')) {
      return "No account found with these credentials.";
    } else if (str.contains('wrong-password')) {
      return "Incorrect password. Please try again.";
    } else if (str.contains('email-already-in-use')) {
      return "An account already exists for this email.";
    } else if (str.contains('network-request-failed')) {
      return "Network connection issue. Please verify internet.";
    }
    return "Authentication failed: ${e.toString()}";
  }
}
