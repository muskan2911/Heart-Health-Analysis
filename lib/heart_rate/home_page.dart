import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0, // Flat AppBar
          title: const Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Profile',
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade200, Colors.teal.shade800],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to your Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDashboardButton(
                        context,
                        'Go to Profile',
                        Icons.person,
                        Colors.teal,
                        '/profile',
                      ),
                      const SizedBox(height: 15),
                      _buildDashboardButton(
                        context,
                        'Monitor Your Heart Health',
                        Icons.favorite,
                        Colors.redAccent,
                        '/heart_health',
                      ),
                      const SizedBox(height: 15),
                      _buildDashboardButton(
                        context,
                        'Health Tips & Resources',
                        Icons.local_hospital,
                        Colors.lightBlue,
                        '/health_tips',
                      ),
                      const SizedBox(height: 15),
                      _buildDashboardButton(
                        context,
                        'About Us',
                        Icons.info,
                        Colors.orangeAccent,
                        '/about_us',
                      ),
                      const SizedBox(height: 15),
                      _buildDashboardButton(
                        context,
                        'Feedback',
                        Icons.feedback,
                        Colors.purpleAccent,
                        '/feedback',
                      ),
                      const SizedBox(height: 15),
                      _buildDashboardButton(
                        context,
                        'Heart Rate Questions',
                        Icons.help,
                        Colors.greenAccent,
                        '/heart_rate_questions',
                      ),
                      const SizedBox(height: 15),
                      // New button for past heart rate activity
                      _buildDashboardButton(
                        context,
                        'Past 30 Days Heart Rate',
                        Icons.access_time,
                        Colors.amber,
                        '/heart_rate_activity',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String label,
      IconData icon, Color color, String route) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50), // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
