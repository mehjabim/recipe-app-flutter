import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import '../Utils/constants.dart';
import 'app_main_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AppAuthProvider>(context);

    if (auth.isInitializing) {
      return const Scaffold(
        backgroundColor: kbackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: kprimaryColor,
          ),
        ),
      );
    }

    if (auth.isAuthenticated) {
      return const AppMainScreen();
    }

    return const LoginScreen();
  }
}
