import 'package:flutter/material.dart';

// The Model Class: Keeps data separate from widgets
class Course {
  final String code;
  final String name;
  final int creditHours;
  final IconData icon;
  final String day;

  const Course(this.code, this.name, this.creditHours, this.icon, this.day);
}

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  // Data stored as a list of Course objects
  final List<Course> _courses = const [
    Course(
      'CSCI 4311',
      'Mobile Application Development',
      3,
      Icons.phone_iphone,
      'Mon & Wed',
    ),
    Course('CSCI 4343', 'Data Science', 3, Icons.analytics, 'Tue & Thu'),
    Course('CSCI 3302', 'Network Security', 3, Icons.security, 'Mon & Wed'),
    Course('INFO 3305', 'Web Technologies', 3, Icons.web, 'Friday'),
    Course('UNGS 2011', 'Creative Thinking', 2, Icons.lightbulb, 'Tue & Thu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(course.icon, size: 36, color: Colors.teal),
              title: Text(
                course.code,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(course.name),
              trailing: Text(
                course.day,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped on ${course.code}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
