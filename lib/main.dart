import 'package:flutter/material.dart';
import 'shell_screen.dart';
import 'screens/about_screen.dart';

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
        useMaterial3: true,
      ),
      home: const ShellScreen(),
      routes: {
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}