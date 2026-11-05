import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/home_screen.dart';
import 'package:campus_buddy_kict/screens/courses_screen.dart';
import 'package:campus_buddy_kict/screens/profile_screen.dart';

class ShellScreen extends StatefulWidget {        // Stateful: it must REMEMBER the current tab
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _tab = 0;                                   // which tab is showing. 0 = Home

  @override
  Widget build(BuildContext context) {
    return Scaffold(                              // NO appBar here, each tab has its own
      body: IndexedStack(                         // holds all 3 screens, shows ONE
        index: _tab,                              // show the screen at this position
        children: const [
          HomeScreen(),                           // tab 0
          CoursesScreen(),                        // tab 1
          ProfileScreen(),                        // tab 2
        ],
      ),
      bottomNavigationBar: NavigationBar(         // the bar of buttons at the bottom
        selectedIndex: _tab,                      // highlight the current tab
        onDestinationSelected: (i) => setState(() => _tab = i), // tapped tab i → remember → redraw
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),   // outline when NOT selected
              selectedIcon: Icon(Icons.home), label: 'Home'),       // filled when selected
          NavigationDestination(icon: Icon(Icons.list_outlined),
              selectedIcon: Icon(Icons.list), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}