import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _exerciseRemindersEnabled = true;
  bool _hydrationRemindersEnabled = false;
  double _heartRateAlertThreshold = 100.0; // Heart rate threshold for alerts
  String _selectedTheme = 'Light';
  String _monitoringFrequency = 'Every Hour'; // Frequency of heart monitoring

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Notifications Settings
            ListTile(
              title: const Text('Enable Notifications'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Exercise Reminders
            ListTile(
              title: const Text('Enable Exercise Reminders'),
              trailing: Switch(
                value: _exerciseRemindersEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _exerciseRemindersEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Hydration Reminders
            ListTile(
              title: const Text('Enable Hydration Reminders'),
              trailing: Switch(
                value: _hydrationRemindersEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _hydrationRemindersEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Heart Rate Alert Threshold Slider
            ListTile(
              title: const Text('Heart Rate Alert Threshold'),
              subtitle: Slider(
                value: _heartRateAlertThreshold,
                min: 60.0,
                max: 150.0,
                divisions: 18,
                label: '${_heartRateAlertThreshold.round()} BPM',
                onChanged: (double value) {
                  setState(() {
                    _heartRateAlertThreshold = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Heart Monitoring Frequency
            ListTile(
              title: const Text('Monitoring Frequency'),
              trailing: DropdownButton<String>(
                value: _monitoringFrequency,
                onChanged: (String? newValue) {
                  setState(() {
                    _monitoringFrequency = newValue!;
                  });
                },
                items: <String>['Every Hour', 'Twice a Day', 'Daily', 'Weekly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Divider(),

            // Theme Selection
            ListTile(
              title: const Text('Theme'),
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTheme = newValue!;
                  });
                },
                items: <String>['Light', 'Dark', 'System Default']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Divider(),

            // Save Settings Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save settings logic here
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Settings Saved!'),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Set the button color
                ),
                child: Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
