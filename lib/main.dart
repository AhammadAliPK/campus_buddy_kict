import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'course_detail_screen.dart';
import 'models/course.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/course-detail') {
          final course = settings.arguments as Course;

          return MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course),
          );
        }

        return null;
      },
    );
  }
}