import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/home_screen.dart';
import 'package:campus_buddy_kict/screens/courses_screen.dart';
import 'package:campus_buddy_kict/screens/profile_screen.dart'; // ← Uncomment when file is added

class NotesStubScreen extends StatelessWidget {
  const NotesStubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Center(child: Text('Notes arrive Week 11')),
    );
  }
}

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          HomeScreen(),
          CoursesScreen(),
          ProfileScreen(),
          NotesStubScreen(), 
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home), 
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined), 
            selectedIcon: Icon(Icons.list), 
            label: 'Courses'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline), 
            selectedIcon: Icon(Icons.person), 
            label: 'Profile'
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined), 
            selectedIcon: Icon(Icons.note_alt), 
            label: 'Notes'
          ),
        ],
      ),
    );
  }
}