import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/shell_screen.dart';
import 'package:campus_buddy_kict/screens/about_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';

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
      '/prayer_times': (context) => const PrayerTimesScreen(),
      '/campus_links': (context) => const CampusLinksScreen(),
    },
    );
  }
}