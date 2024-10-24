import 'package:flutter/material.dart';
import 'package:heart_rate_monitor_app/auth/login_page.dart';
import 'package:heart_rate_monitor_app/auth/signup_page.dart';

class AuthPageNew extends StatefulWidget {
  const AuthPageNew({super.key});

  @override
  State<AuthPageNew> createState() => _AuthPageNewState();
}

class _AuthPageNewState extends State<AuthPageNew> {
  bool showLoginPage = true;

  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreen);
    } else {
      return SignUpPage(showLoginPage: toggleScreen);
    }
  }
}
