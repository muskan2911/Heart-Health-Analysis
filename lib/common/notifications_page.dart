import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Heart Rate Alert',
      'subtitle': 'Your heart rate exceeded 100 bpm',
      'icon': Icons.favorite,
      'time': '5 min ago',
    },
    {
      'title': 'Weekly Report Available',
      'subtitle': 'Your heart health report for this week is ready',
      'icon': Icons.insert_chart,
      'time': '30 min ago',
    },
    {
      'title': 'Check Your Heart Rate',
      'subtitle': 'It\'s time to check your heart rate',
      'icon': Icons.health_and_safety,
      'time': '2 hours ago',
    },
    {
      'title': 'Exercise Reminder',
      'subtitle': 'Time for your daily 30-minute exercise',
      'icon': Icons.directions_run,
      'time': '3 hours ago',
    },
    {
      'title': 'Hydration Reminder',
      'subtitle': 'Stay hydrated! Drink a glass of water now.',
      'icon': Icons.local_drink,
      'time': '4 hours ago',
    },
  ];

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heart Health Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: Icon(notification['icon']),
            title: Text(notification['title']),
            subtitle: Text(notification['subtitle']),
            trailing: Text(notification['time']),
            onTap: () {
              // Action when notification is tapped (e.g., view detailed report)
            },
          );
        },
      ),
    );
  }
}
