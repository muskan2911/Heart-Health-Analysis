import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = 'Male';
  DateTime? _dateOfBirth;
  File? _selectedImage;
  String? _profileImageUrl;

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
          _gender = snapshot['gender'] ?? 'Male';
          _dateOfBirth = (snapshot['date_of_birth'] as Timestamp?)?.toDate();
          _profileImageUrl = snapshot['profile_image_url'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_selectedImage!);
      _profileImageUrl = await storageRef.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _submitUserInfo() async {
    try {
      await _uploadImage(); // Upload the image first
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        int age = _dateOfBirth != null ? _calculateAge(_dateOfBirth!) : 0;

        Map<String, dynamic> userData = {
          'name': _nameController.text,
          'age': age,
          'gender': _gender,
          'date_of_birth':
              _dateOfBirth != null ? Timestamp.fromDate(_dateOfBirth!) : null,
          'profile_image_url': _profileImageUrl,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData);
        Navigator.of(context).pop();
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
                // Profile Image Display
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(Icons.camera_alt,
                            size: 18, color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                            _dateOfBirth = picked;
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
                    onPressed: _submitUserInfo,
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
