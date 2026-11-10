import 'package:flutter/cupertino.dart';
import 'package:campus_buddy_kict/screens/home_screen.dart';
import 'package:campus_buddy_kict/screens/courses_screen.dart';
import 'package:campus_buddy_kict/screens/profile_screen.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeScreen();
          case 1:
            return const CoursesScreen();
          case 2:
          default:
            return const ProfileScreen();
        }
      },
    );
  }
}