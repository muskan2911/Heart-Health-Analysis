import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _nameController.text = snapshot['name'] ?? '';
          _ageController.text = snapshot['age']?.toString() ?? '';
          _gender = snapshot['gender'] ?? 'Male';
          _dateOfBirth = (snapshot['date_of_birth'] as Timestamp?)?.toDate();
        });
      }
    }
  }

  void _submitUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Map<String, dynamic> userData = {
          'name': _nameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _gender,
          'date_of_birth':
              _dateOfBirth != null ? Timestamp.fromDate(_dateOfBirth!) : null,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData);
        Navigator.of(context);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 120, height: 120),
                const SizedBox(height: 30),
                // Name Input Field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                // Age Input Field
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['Male', 'Female', 'Other']
                      .map((gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Date of Birth Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _dateOfBirth == null
                          ? 'Select Date of Birth'
                          : 'DOB: ${DateFormat('yyyy-MM-dd').format(_dateOfBirth!)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _dateOfBirth ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != _dateOfBirth) {
                          setState(() {
                            _dateOfBirth = picked; // Set the picked date
                          });
                        }
                      },
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitUserInfo();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Submit', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
