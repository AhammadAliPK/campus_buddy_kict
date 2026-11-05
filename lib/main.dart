import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/shell_screen.dart';   // so main.dart knows ShellScreen
import 'package:campus_buddy_kict/screens/about_screen.dart';
void main() => runApp(const CampusBuddyKictApp());

class CampusBuddyKictApp extends StatelessWidget {
   const CampusBuddyKictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Buddy KICT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ShellScreen(),  // the app now opens on the shell (with the bottom bar)
      routes: {                                       // the app's address book
        '/about': (context) => const AboutScreen(),   // name '/about' → this screen
      },
    );
  }
}