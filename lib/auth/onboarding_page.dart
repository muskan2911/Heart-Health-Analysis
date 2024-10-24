import 'package:flutter/material.dart';
import 'package:heart_rate_monitor_app/auth/login_page.dart';
import 'package:heart_rate_monitor_app/auth/signup_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background for a clean look
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add an illustrative image or icon at the top
            Image.asset('assets/logo.png', width: 150, height: 150),
            const SizedBox(height: 40),

            // Welcome text with style
            const Text(
              'Welcome to Heart Health App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent, // A heart-health related color
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Brief description or tagline
            Text(
              'Track your heart health, get personalized tips, and stay fit!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Large button for "Get Started"
            SizedBox(
              width: double.infinity, // Full-width button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpPage(showLoginPage: () {
                                Navigator.pop(context);
                              })));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Theme color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16), // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Rounded button for a modern look
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Add a skip button or more navigation options if necessary
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(showRegisterPage: () {
                              Navigator.pop(context);
                            })));
              },
              child: const Text(
                'Already have an account? Login',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
