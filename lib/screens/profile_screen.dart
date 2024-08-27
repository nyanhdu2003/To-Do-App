import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _image;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController socialController = TextEditingController();

  String _name = '';
  String _phone = '';
  String _address = '';
  String _email = '';
  String _socialMedia = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        final docSnapshot = await _firestore.collection('users').doc(uid).get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _name = userData['full_name'] ?? 'Not provided';
            _phone = userData['phone_number'] ?? 'Not provided';
            _address = userData['address'] ?? 'Not provided';
            _email = userData['email'] ?? 'Not provided';
            _socialMedia = userData['social_media'] ?? 'Not provided';

            // Initialize controllers
            nameController.text = _name;
            phoneController.text = _phone;
            addressController.text = _address;
            emailController.text = _email;
            socialController.text = _socialMedia;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch user data: $e'),
        ),
      );
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    // Save profile changes logic here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _image != null
                  ? CircleAvatar(
                radius: 65,
                backgroundImage: MemoryImage(_image!),
              )
                  : Stack(
                children: [
                  const CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=',
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo, color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    itemProfile('Name', nameController, Icons.person, context),
                    const SizedBox(height: 10),
                    itemProfile('Phone', phoneController, Icons.phone, context),
                    const SizedBox(height: 10),
                    itemProfile('Address', addressController, Icons.location_on, context),
                    const SizedBox(height: 10),
                    itemProfile('Email', emailController, Icons.mail, context, enabled: false, isDark: true),
                    const SizedBox(height: 10),
                    itemProfile('Social Media', socialController, Icons.app_shortcut, context),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemProfile(
      String title, TextEditingController controller, IconData icon, BuildContext context,
      {bool enabled = true, bool isDark = false}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final Color iconColor = isDarkMode ? Colors.black : theme.iconTheme.color!;
    final Color containerColor = isDarkMode ? Colors.white : Colors.white;
    final Color textColor = isDark ? Colors.grey[600]! : Colors.black87; // Darker color for disabled fields

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.lightBlueAccent,
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: TextField(
          controller: controller,
          enabled: enabled,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            border: InputBorder.none,
          ),
        ),
        leading: Icon(icon, color: iconColor),
      ),
    );
  }
}
