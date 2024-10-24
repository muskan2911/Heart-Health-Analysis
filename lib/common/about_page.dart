import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Heart Health App',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'The Heart Health App is designed to help users monitor their heart rate, analyze heart health patterns, and promote a healthier lifestyle. '
                      'Using advanced facial recognition and machine learning algorithms, the app can calculate heart rate using a simple video of your face. '
                      'It also provides personalized insights and reminders to help you manage your heart health.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Key Features'),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    BulletPoint(
                        text:
                            'Real-time heart rate monitoring using your camera'),
                    BulletPoint(
                        text:
                            'Weekly heart health reports and personalized insights'),
                    BulletPoint(text: 'Exercise and hydration reminders'),
                    BulletPoint(
                        text: 'Alerts for irregular heart rate patterns'),
                    BulletPoint(
                        text:
                            'User-friendly interface and secure data storage'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Our Mission'),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Our mission is to empower individuals to take control of their heart health by providing accessible and accurate heart monitoring tools. '
                  'With this app, we hope to promote early detection of heart conditions and encourage a proactive approach to health management.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildSectionTitle('Contact Us'),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.email, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'For support or inquiries, feel free to contact our team at: \n\nsupport@hearthealthapp.com',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade900,
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.teal),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
