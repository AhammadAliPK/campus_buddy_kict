import 'package:flutter/cupertino.dart';
import 'package:campus_buddy_kict/screens/shell_screen.dart';
import 'package:campus_buddy_kict/screens/about_screen.dart';

void main() => runApp(const CampusBuddyKictApp());

class CampusBuddyKictApp extends StatelessWidget {
  const CampusBuddyKictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Campus Buddy KICT',
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: const ShellScreen(),
      routes: {
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}