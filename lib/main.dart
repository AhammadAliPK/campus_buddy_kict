import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/about_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/home_screen.dart';
import 'screens/links_screen.dart';
import 'screens/more_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const CampusBuddyKictApp());
}

class CampusBuddyKictApp extends StatefulWidget {
  const CampusBuddyKictApp({super.key});

  @override
  State<CampusBuddyKictApp> createState() => _CampusBuddyKictAppState();
}

class _CampusBuddyKictAppState extends State<CampusBuddyKictApp> {
  final CampusBuddyState appState = CampusBuddyState();

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        return MaterialApp(
          title: 'Campus Buddy KICT',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff1f8a70),
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xfff5faf8),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          home: AppShell(appState: appState),
          routes: {
            '/about': (_) => const AboutScreen(),
            '/links': (_) => LinksScreen(appState: appState),
          },
        );
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({required this.appState, super.key});

  final CampusBuddyState appState;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    HomeScreen(
      appState: widget.appState,
      onOpenCourses: () => setState(() => _selectedIndex = 1),
      onOpenLinks: () => Navigator.of(context).pushNamed('/links'),
    ),
    CoursesScreen(appState: widget.appState),
    NotesScreen(appState: widget.appState),
    ProfileScreen(appState: widget.appState),
    MoreScreen(appState: widget.appState),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.notes_outlined),
            selectedIcon: Icon(Icons.notes),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
