//import 'package:campus_buddy_kict/screens/courses_screen.dart';
import 'package:campus_buddy_kict/shell_screen.dart';
import 'package:campus_buddy_kict/screens/about_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart'; // NEW
import 'package:campus_buddy_kict/screens/campus_links_screen.dart'; // NEW 
import 'package:flutter/material.dart';

void main() => runApp(const CampusBuddyKictApp());

class CampusBuddyKictApp extends StatelessWidget {
  const CampusBuddyKictApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Buddy KICT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ShellScreen(),
      routes: {
        '/about': (context) => const AboutScreen(),
        '/prayer': (context) => const PrayerTimesScreen(),
        '/links': (context) => const CampusLinksScreen(),
      },
    );
  }
}
