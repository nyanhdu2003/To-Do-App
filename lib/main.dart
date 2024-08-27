import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/screens/update_profilescreen.dart';
import 'package:todo_list_app/screens/favorite_screen.dart';
import 'package:todo_list_app/screens/login_screen.dart';
import 'package:todo_list_app/screens/signup_screen.dart';
import 'package:todo_list_app/screens/profile_screen.dart';
import 'package:todo_list_app/theme/theme.dart';
import 'package:todo_list_app/theme/theme_provider.dart';
import 'package:todo_list_app/screens/welcome_screen.dart';
import 'screens/homepage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MaterialApp(
        title: 'Named Routes',
        theme: lightMode,
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/signIn': (context) => const SignInScreen(),
          '/signUp': (context) => const SignUpScreen(),
          '/home': (context) => const Homepage(),
          '/ProfileScreen': (context) =>  const ProfileScreen(),
          '/favoriteScreen': (context) => const FavoriteScreen(),
          // '/update': (context) => const UpdateProfile(initialData: {},),
        },
        debugShowCheckedModeBanner: false,
      )));
}
