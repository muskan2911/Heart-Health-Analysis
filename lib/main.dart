import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:heart_rate_monitor_app/common/heart_rate_questions_page.dart';
import 'package:heart_rate_monitor_app/heart_rate/heart_rate_service.dart';
import 'package:heart_rate_monitor_app/auth/splash_page.dart';
import 'package:heart_rate_monitor_app/auth/onboarding_page.dart';
import 'package:heart_rate_monitor_app/heart_rate/home_page.dart';
import 'package:heart_rate_monitor_app/auth/forgot_password_page.dart';
import 'package:heart_rate_monitor_app/records/profile_page.dart';
import 'package:heart_rate_monitor_app/common/health_tips_page.dart';
import 'package:heart_rate_monitor_app/common/settings_page.dart';
import 'package:heart_rate_monitor_app/common/notifications_page.dart';
import 'package:heart_rate_monitor_app/common/feedback_page.dart';
import 'package:heart_rate_monitor_app/common/about_page.dart';
import 'package:heart_rate_monitor_app/auth/logout_confirmation_page.dart';
import 'package:heart_rate_monitor_app/heart_rate/heart_rate_activity_page.dart'; // Import Heart Rate Activity page
import 'package:heart_rate_monitor_app/records/past_month_heart_rate_page.dart'; // Import Past Month page
import 'package:heart_rate_monitor_app/records/past_week_heart_rate_page.dart'; // Import Past Week page
import 'package:heart_rate_monitor_app/records/past_day_heart_rate_page.dart'; // Import Past Day page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(HeartHealthApp());
}

class HeartHealthApp extends StatelessWidget {
  const HeartHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/onboarding': (context) => OnboardingPage(),
        '/home': (context) => HomePage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/profile': (context) => UserInfoPage(),
        '/health_tips': (context) => HealthTipsPage(),
        '/settings': (context) => SettingsPage(),
        '/notifications': (context) => NotificationsPage(),
        '/feedback': (context) => FeedbackPage(),
        '/about_us': (context) => AboutPage(),
        '/logout': (context) => LogoutConfirmationPage(),
        '/heart_rate_questions': (context) => HeartRateQuestionsPage(),
        '/heart_rate_activity': (context) =>
            HeartRateActivityPage(), // New route for Heart Rate Activity
        '/past_month': (context) =>
            PastMonthHeartRatePage(), // New route for Past Month Heart Rate
        '/past_week': (context) =>
            PastWeekHeartRatePage(), // New route for Past Week Heart Rate
        '/past_day': (context) =>
            PastDayHeartRatePage(), // New route for Past Day Heart Rate
        '/heart_health': (context) =>
            HeartRateMonitorPage(), // New route for Heart Health Monitoring
      },
    );
  }
}
