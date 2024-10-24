import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthTipsPage extends StatefulWidget {
  const HealthTipsPage({super.key});

  @override
  _HealthTipsPageState createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage> {
  User? user = FirebaseAuth.instance.currentUser; // Get current user
  Map<String, dynamic>? userResponses; // To store user responses

  @override
  void initState() {
    super.initState();
    _fetchUserResponses(); // Fetch user responses from Firestore
  }

  // Fetch the user's saved responses from Firestore
  Future<void> _fetchUserResponses() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user!.uid)
          .collection('questionnaire')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userResponses = snapshot.data(); // Store the user's responses
        });
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Health Tips & Resources'),
        backgroundColor: Colors.teal,
      ),
      body: userResponses == null
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SectionTitle(title: 'Heart Health Tips'),
                  ..._generateHeartHealthTips(),

                  const SizedBox(height: 20), // Spacer

                  const SectionTitle(title: 'Exercise Tips'),
                  ..._generateExerciseTips(),

                  const SizedBox(height: 20), // Spacer

                  const SectionTitle(title: 'Nutrition Tips'),
                  ..._generateNutritionTips(),

                  const SizedBox(height: 20), // Spacer

                  const SectionTitle(title: 'Lifestyle Changes'),
                  ..._generateLifestyleTips(),
                ],
              ),
            ),
    );
  }

  // Generate heart health tips based on the user's responses
  List<Widget> _generateHeartHealthTips() {
    List<Widget> tips = [];

    if (userResponses!['exerciseFrequency'] == 'Never' ||
        userResponses!['exerciseFrequency'] == '1-2 times') {
      tips.add(const TipCard(
          tip:
              'Try to incorporate more physical activity into your routine to strengthen your heart.'));
    }

    if (userResponses!['familyHistory'] == 'Yes') {
      tips.add(const TipCard(
          tip:
              'Since you have a family history of cardiovascular disease, regular heart check-ups are recommended.'));
    }

    if (userResponses!['smokingStatus'] == 'Yes') {
      tips.add(const TipCard(
          tip: 'Consider quitting smoking to improve heart health.'));
    }

    return tips.isNotEmpty
        ? tips
        : [const TipCard(tip: 'Keep monitoring your heart health regularly!')];
  }

  // Generate exercise tips based on the user's responses
  List<Widget> _generateExerciseTips() {
    List<Widget> tips = [];

    if (userResponses!['exerciseFrequency'] == 'Never') {
      tips.add(const TipCard(
          tip:
              'Start small: aim for at least 10 minutes of exercise each day.'));
    } else if (userResponses!['exerciseFrequency'] == '1-2 times') {
      tips.add(const TipCard(
          tip:
              'Increase the frequency of your workouts to at least 3 times per week for optimal health.'));
    }

    if (userResponses!['workoutDuration'] == 'Less than 15 minutes') {
      tips.add(const TipCard(
          tip:
              'Try to gradually extend your workout sessions to 30 minutes for better results.'));
    }

    return tips.isNotEmpty
        ? tips
        : [const TipCard(tip: 'Great job! Keep up your exercise routine!')];
  }

  // Generate nutrition tips based on the user's responses
  List<Widget> _generateNutritionTips() {
    List<Widget> tips = [];

    if (userResponses!['dietType'] == 'Unhealthy') {
      tips.add(const TipCard(
          tip:
              'Consider incorporating more fruits, vegetables, and whole grains into your diet.'));
    }

    if (userResponses!['waterIntake'] == 'Less than 1 liter') {
      tips.add(
          const TipCard(tip: 'Aim to drink at least 2 liters of water daily.'));
    }

    return tips.isNotEmpty
        ? tips
        : [const TipCard(tip: 'Keep up your healthy eating habits!')];
  }

  // Generate lifestyle tips based on the user's responses
  List<Widget> _generateLifestyleTips() {
    List<Widget> tips = [];

    if (userResponses!['stressLevel'] == 'High' ||
        userResponses!['stressLevel'] == 'Very high') {
      tips.add(const TipCard(
          tip:
              'Try practicing relaxation techniques like yoga or meditation to manage stress.'));
    }

    if (userResponses!['sleepHours'] == 'Less than 5 hours') {
      tips.add(const TipCard(
          tip: 'Aim to get at least 7-8 hours of sleep each night.'));
    }

    return tips.isNotEmpty
        ? tips
        : [
            const TipCard(tip: 'Maintain a balanced lifestyle to stay healthy!')
          ];
  }
}

// Widget to display section titles
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
}

// Widget to display individual tips
class TipCard extends StatelessWidget {
  final String tip;

  const TipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          tip,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
