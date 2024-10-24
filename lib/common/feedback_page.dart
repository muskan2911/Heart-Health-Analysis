import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _feedbackType = 'General Feedback';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback/Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _feedbackType,
                decoration: const InputDecoration(
                  labelText: 'Feedback Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _feedbackType = newValue!;
                  });
                },
                items: <String>[
                  'General Feedback',
                  'Report an Issue',
                  'Request Support'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Your Message',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Get current user
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Prepare data
                      Map<String, dynamic> feedbackData = {
                        'name': _name,
                        'email': _email,
                        'message': _message,
                        'timestamp': FieldValue.serverTimestamp(),
                      };

                      // Save to Firestore in the appropriate collection
                      await FirebaseFirestore.instance
                          .collection(
                              _feedbackType) // Use feedback type as collection name
                          .doc(user.uid) // Use user UID as document ID
                          .set(feedbackData)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feedback Submitted')),
                        );
                        // Clear fields after submission
                        setState(() {
                          _name = '';
                          _email = '';
                          _message = '';
                          _feedbackType = 'General Feedback';
                        });
                      }).catchError((error) {
                        print("Error submitting feedback: $error");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error submitting feedback')),
                        );
                      });
                    }
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
}
