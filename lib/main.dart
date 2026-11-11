import 'package:flutter/material.dart'; // Change to material import (or keep both if needed)
import 'package:campus_buddy_kict/screens/shell_screen.dart';
import 'package:campus_buddy_kict/screens/about_screen.dart';

void main() => runApp(const CampusBuddyKictApp());

class CampusBuddyKictApp extends StatelessWidget {
  const CampusBuddyKictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Change CupertinoApp to MaterialApp
      title: 'Campus Buddy KICT',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const ShellScreen(),
      routes: {
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}