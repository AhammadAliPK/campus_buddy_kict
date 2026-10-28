
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/courses_screen.dart';
import 'package:campus_buddy_kict/profile_screen.dart';

void main() {
  runApp(const CampusBuddyKictApp());
}

class CampusBuddyKictApp extends StatelessWidget {
  const CampusBuddyKictApp({super.key});

  static const Color turquoise = Color(0xFF009FA3);
  static const Color darkTurquoise = Color(0xFF007C80);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Buddy KICT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: turquoise,
          brightness: Brightness.light,
        ).copyWith(
          primary: turquoise,
          secondary: darkTurquoise,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4FAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: darkTurquoise,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: darkTurquoise,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF4FAFA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFDCEEEE),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: turquoise,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const CampusHomeScreen(),
    );
  }
}

class CampusHomeScreen extends StatefulWidget {
  const CampusHomeScreen({super.key});

  @override
  State<CampusHomeScreen> createState() => _CampusHomeScreenState();
}

class _CampusHomeScreenState extends State<CampusHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD7F3F1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
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
