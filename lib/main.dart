import 'package:campus_buddy_kict/courses_screen.dart';
import 'package:campus_buddy_kict/profile_screen.dart';
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
      home: const CampusBuddyHome(),
    );
  }
}

class CampusBuddyHome extends StatefulWidget {
  const CampusBuddyHome({super.key});

  @override
  State<CampusBuddyHome> createState() => _CampusBuddyHomeState();
}

class _CampusBuddyHomeState extends State<CampusBuddyHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
