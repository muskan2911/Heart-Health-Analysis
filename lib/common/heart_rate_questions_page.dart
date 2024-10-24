import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package for saving responses
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HeartRateQuestionsPage extends StatefulWidget {
  // User ID of the current user

  const HeartRateQuestionsPage({super.key});

  @override
  _HeartRateQuestionsPageState createState() => _HeartRateQuestionsPageState();
}

class _HeartRateQuestionsPageState extends State<HeartRateQuestionsPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String?> _selectedAnswers = {};

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Rate & Lifestyle Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Please answer the following questions about your lifestyle:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildQuestion('1. How often do you exercise per week?'),
              _buildOptions(
                  ['Never', '1-2 times', '3-4 times', '5 or more times'],
                  'exerciseFrequency'),
              _buildQuestion(
                  '2. How long do your workout sessions usually last?'),
              _buildOptions([
                'Less than 15 minutes',
                '15-30 minutes',
                '30-60 minutes',
                'More than 60 minutes'
              ], 'workoutDuration'),
              _buildQuestion(
                  '3. Do you have any history of cardiovascular disease in your family?'),
              _buildOptions(['Yes', 'No'], 'familyHistory'),
              _buildQuestion(
                  '4. How would you rate your stress levels on an average day?'),
              _buildOptions(
                  ['Low', 'Moderate', 'High', 'Very high'], 'stressLevel'),
              _buildQuestion(
                  '5. How many hours of sleep do you get per night?'),
              _buildOptions([
                'Less than 5 hours',
                '5-6 hours',
                '7-8 hours',
                'More than 8 hours'
              ], 'sleepHours'),
              _buildQuestion('6. Do you smoke or use tobacco products?'),
              _buildOptions(['Yes', 'No', 'Occasionally'], 'smokingStatus'),
              _buildQuestion('7. How would you describe your daily diet?'),
              _buildOptions(
                  ['Unhealthy', 'Moderate', 'Healthy', 'Very healthy'],
                  'dietType'),
              _buildQuestion('8. How much water do you drink per day?'),
              _buildOptions([
                'Less than 1 liter',
                '1-2 liters',
                '2-3 liters',
                'More than 3 liters'
              ], 'waterIntake'),
              _buildQuestion('9. Do you consume caffeinated drinks regularly?'),
              _buildOptions(['Yes', 'No'], 'caffeineConsumption'),
              _buildQuestion(
                  '10. How often do you feel fatigued or tired during the day?'),
              _buildOptions(['Rarely', 'Sometimes', 'Often', 'Always'],
                  'fatigueFrequency'),
              _buildQuestion('11. Do you consume alcohol?'),
              _buildOptions(['Never', 'Occasionally', 'Frequently'],
                  'alcoholConsumption'),
              _buildQuestion(
                  '12. How would you describe your work environment?'),
              _buildOptions([
                'Low stress',
                'Moderate stress',
                'High stress',
                'Very high stress'
              ], 'workEnvironment'),
              _buildQuestion(
                  '13. Have you noticed any unusual changes in your heart rate recently?'),
              _buildOptions(['Yes', 'No'], 'heartRateChanges'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Calculate the heart health
                    String healthStatus = _determineHeartHealth();

                    // Save the responses and health status to Firestore
                    _saveResponses(healthStatus);

                    _viewReport();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build question widget
  Widget _buildQuestion(String question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        question,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Build options widget
  Widget _buildOptions(List<String> options, String questionKey) {
    return Column(
      children: options.map((option) {
        return ListTile(
          title: Text(option),
          leading: Radio(
            value: option,
            groupValue: _selectedAnswers[questionKey],
            onChanged: (value) {
              setState(() {
                _selectedAnswers[questionKey] = value as String;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  // Determine heart health based on the responses
  String _determineHeartHealth() {
    int score = 0;

    // Scoring rules for exercise frequency
    if (_selectedAnswers['exerciseFrequency'] == '5 or more times') {
      score += 3;
    } else if (_selectedAnswers['exerciseFrequency'] == '3-4 times')
      score += 2;
    else if (_selectedAnswers['exerciseFrequency'] == '1-2 times') score += 1;

    // Scoring rules for workout duration
    if (_selectedAnswers['workoutDuration'] == 'More than 60 minutes') {
      score += 3;
    } else if (_selectedAnswers['workoutDuration'] == '30-60 minutes')
      score += 2;
    else if (_selectedAnswers['workoutDuration'] == '15-30 minutes') score += 1;

    // Scoring for family history
    if (_selectedAnswers['familyHistory'] == 'No') score += 2;

    // Scoring for stress levels
    if (_selectedAnswers['stressLevel'] == 'Low') {
      score += 3;
    } else if (_selectedAnswers['stressLevel'] == 'Moderate')
      score += 2;
    else if (_selectedAnswers['stressLevel'] == 'High') score += 1;

    // Scoring for sleep hours
    if (_selectedAnswers['sleepHours'] == 'More than 8 hours') {
      score += 3;
    } else if (_selectedAnswers['sleepHours'] == '7-8 hours')
      score += 2;
    else if (_selectedAnswers['sleepHours'] == '5-6 hours') score += 1;

    // Scoring for smoking/tobacco use
    if (_selectedAnswers['smokingStatus'] == 'No') {
      score += 2;
    } else if (_selectedAnswers['smokingStatus'] == 'Occasionally') score += 1;

    // Scoring for diet quality
    if (_selectedAnswers['dietType'] == 'Very healthy') {
      score += 3;
    } else if (_selectedAnswers['dietType'] == 'Healthy')
      score += 2;
    else if (_selectedAnswers['dietType'] == 'Moderate') score += 1;

    // Scoring for water intake
    if (_selectedAnswers['waterIntake'] == 'More than 3 liters') {
      score += 3;
    } else if (_selectedAnswers['waterIntake'] == '2-3 liters')
      score += 2;
    else if (_selectedAnswers['waterIntake'] == '1-2 liters') score += 1;

    // Scoring for caffeine consumption
    if (_selectedAnswers['caffeineConsumption'] == 'No') score += 1;

    // Scoring for fatigue/tiredness
    if (_selectedAnswers['fatigueFrequency'] == 'Rarely') {
      score += 3;
    } else if (_selectedAnswers['fatigueFrequency'] == 'Sometimes')
      score += 2;
    else if (_selectedAnswers['fatigueFrequency'] == 'Often') score += 1;

    // Scoring for alcohol consumption
    if (_selectedAnswers['alcoholConsumption'] == 'Never') {
      score += 2;
    } else if (_selectedAnswers['alcoholConsumption'] == 'Occasionally')
      score += 1;

    // Scoring for work environment stress
    if (_selectedAnswers['workEnvironment'] == 'Low stress') {
      score += 3;
    } else if (_selectedAnswers['workEnvironment'] == 'Moderate stress')
      score += 2;
    else if (_selectedAnswers['workEnvironment'] == 'High stress') score += 1;

    // Scoring for heart rate changes
    if (_selectedAnswers['heartRateChanges'] == 'No') score += 2;

    // Determine health category based on total score
    if (score >= 41) {
      return 'Excellent';
    } else if (score >= 31)
      return 'Good';
    else if (score >= 21)
      return 'Okay';
    else if (score >= 11) return 'Poor';
    return 'Very Poor';
  }

  void _viewReport() async {
    // Calculate average BPM

    // Show the report dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Heart Rate Report'),
          content: Row(
            children: [
              const Text(
                'Your Health Status is ',
              ),
              Text(
                _determineHeartHealth(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Save responses and health status to Firestore
  void _saveResponses(String healthStatus) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid) // Use the current user's ID
        .collection('questionnaire')
        .doc(user!.uid)
        .set({
      'exerciseFrequency': _selectedAnswers['exerciseFrequency'],
      'workoutDuration': _selectedAnswers['workoutDuration'],
      'familyHistory': _selectedAnswers['familyHistory'],
      'stressLevel': _selectedAnswers['stressLevel'],
      'sleepHours': _selectedAnswers['sleepHours'],
      'smokingStatus': _selectedAnswers['smokingStatus'],
      'dietType': _selectedAnswers['dietType'],
      'waterIntake': _selectedAnswers['waterIntake'],
      'caffeineConsumption': _selectedAnswers['caffeineConsumption'],
      'fatigueFrequency': _selectedAnswers['fatigueFrequency'],
      'alcoholConsumption': _selectedAnswers['alcoholConsumption'],
      'workEnvironment': _selectedAnswers['workEnvironment'],
      'heartRateChanges': _selectedAnswers['heartRateChanges'],
      'healthStatus': healthStatus, // The computed heart health status
      'timestamp': FieldValue
          .serverTimestamp(), // Add timestamp to track submission time
    });
  }
}
