// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';
//
// class UpdateProfile extends StatefulWidget {
//   final Map<String, dynamic> initialData;
//
//   const UpdateProfile({Key? key, required this.initialData}) : super(key: key);
//
//   @override
//   UpdateProfileState createState() => UpdateProfileState();
// }
//
// class UpdateProfileState extends State<UpdateProfile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Uint8List? _image;
//
//   // TextEditingControllers for each field
//   late TextEditingController _nameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late TextEditingController _emailController;
//   late TextEditingController _socialMediaController;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.initialData['full_name']);
//     _phoneController = TextEditingController(text: widget.initialData['phone_number']);
//     _addressController = TextEditingController(text: widget.initialData['address']);
//     _emailController = TextEditingController(text: widget.initialData['email']);
//     _socialMediaController = TextEditingController(text: widget.initialData['social_media']);
//   }
//
//   void selectImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       final Uint8List image = await pickedFile.readAsBytes();
//       setState(() {
//         _image = image;
//       });
//
//       final user = _auth.currentUser;
//       if (user != null) {
//         // Code to upload image to Firebase Storage and update user profile
//       }
//     }
//   }
//
//   Future<void> _updateUserProfile() async {
//     final User? user = _auth.currentUser;
//     if (user != null) {
//       final uid = user.uid;
//
//       try {
//         // Update Firestore with the new data
//         await _firestore.collection('users').doc(uid).update({
//           'full_name': _nameController.text,
//           'phone_number': _phoneController.text,
//           'address': _addressController.text,
//           'email': _emailController.text,
//           'social_media': _socialMediaController.text,
//         });
//
//         // Pass the updated data back to ProfileScreen
//         Navigator.pop(context, {
//           'full_name': _nameController.text,
//           'phone_number': _phoneController.text,
//           'address': _addressController.text,
//           'email': _emailController.text,
//           'social_media': _socialMediaController.text,
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update profile: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controllers when the widget is disposed
//     _nameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _emailController.dispose();
//     _socialMediaController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Edit Profile'),
//           backgroundColor: Colors.blue,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.blueAccent,
//                       width: 6.0,
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       _image != null
//                           ? CircleAvatar(
//                         radius: 100,
//                         backgroundImage: MemoryImage(_image!),
//                       )
//                           : CircleAvatar(
//                         radius: 100,
//                         backgroundColor: Colors.white,
//                         child: ClipOval(
//                           child: _auth.currentUser?.photoURL != null
//                               ? Image.network(
//                             _auth.currentUser!.photoURL!,
//                             fit: BoxFit.cover,
//                             width: 150,
//                             height: 150,
//                           )
//                               : Image.asset(
//                             'images/defaultProfilePicture.jpg',
//                             fit: BoxFit.cover,
//                             width: 150,
//                             height: 150,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: -10,
//                         left: 90,
//                         child: IconButton(
//                           onPressed: selectImage,
//                           icon: const Icon(
//                             Icons.add_a_photo,
//                             size: 30,
//                           ),
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     itemProfile('Name', _nameController, Icons.person, context),
//                     const SizedBox(height: 10),
//                     itemProfile('Phone', _phoneController, Icons.phone, context),
//                     const SizedBox(height: 10),
//                     itemProfile(
//                         'Address', _addressController, Icons.location_on, context),
//                     const SizedBox(height: 10),
//                     itemProfile('Email', _emailController, Icons.mail, context),
//                     const SizedBox(height: 10),
//                     itemProfile('Social Media', _socialMediaController,
//                         Icons.app_shortcut, context),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: _updateUserProfile,
//                 child: const Text('Confirm'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget itemProfile(String title, TextEditingController controller,
//       IconData icon, BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     final Color iconColor = isDarkMode ? Colors.black : theme.iconTheme.color!;
//     final Color containerColor = isDarkMode ? Colors.white : Colors.white;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: containerColor,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: const [
//           BoxShadow(
//             offset: Offset(0, 5),
//             color: Colors.lightBlueAccent,
//             spreadRadius: 5,
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: ListTile(
//         title: TextField(
//           controller: controller,
//           style: const TextStyle(
//               color: Colors.black87,),
//           decoration: InputDecoration(
//             labelText: title,
//             labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//             border: InputBorder.none,
//           ),
//         ),
//         leading: Icon(icon, color: iconColor),
//       ),
//     );
//   }
// }
