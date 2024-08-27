import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  Menu({super.key, required this.contextHome});

  final BuildContext contextHome;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore1 = FirebaseFirestore.instance;

  Future<String> _fetchUserName(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore1.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.get('full_name') ?? 'User Name';
      }
    } catch (e) {
      // Handle error
      print('Failed to get user name $e');
    }
    return 'User Name'; // Default value
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    // If the user is not logged in
    if (user == null) {
      return const Drawer(
        child: Center(child: Text('No user logged in')),
      );
    }

    // Get user's full name and email
    return FutureBuilder<String>(
      future: _fetchUserName(user.uid),
      builder: (context, snapshot) {
        final fullName = snapshot.data ?? 'User Name';
        final email = user.email ?? 'User Email';

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200.0, // Adjust as per your needs
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/Anhbia.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  UserAccountsDrawerHeader(
                    accountName: Text(fullName),
                    accountEmail: Text(email),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: user.photoURL != null
                            ? Image.network(
                          user.photoURL!,
                          fit: BoxFit.cover,
                          height: 90,
                          width: 90,
                        )
                            : Image.asset(
                          'images/defaultProfilePicture.jpg',
                          fit: BoxFit.cover,
                          height: 90,
                          width: 90,
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent, // Make background transparent
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/ProfileScreen');
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favorite Tasks'),
                onTap: () {
                  Navigator.pushNamed(context, '/favoriteScreen');
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_rounded),
                title: const Text('Notifications'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log Out'),
                onTap: () async {
                  // Sign out and close menu
                  for (var i = 0; i < 2; i++) {
                    Navigator.pop(contextHome);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
