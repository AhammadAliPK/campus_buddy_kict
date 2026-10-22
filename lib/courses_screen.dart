import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  final List<Map<String, String>> _courses = const [
    {
      'code': 'CSCI 4311',
      'title': 'Mobile Application Development',
      'section': 'Section 1',
      'time': 'Mon & Wed, 10:00 AM - 11:20 AM',
    },
    {
      'code': 'CSCI 4343',
      'title': 'Data Science',
      'section': 'Section 2',
      'time': 'Tue & Thu, 2:00 PM - 3:20 PM',
    },
    {
      'code': 'CSCI 3302',
      'title': 'Network Security',
      'section': 'Section 1',
      'time': 'Mon & Wed, 8:30 AM - 9:50 AM',
    },
    {
      'code': 'INFO 3305',
      'title': 'Web Technologies',
      'section': 'Section 3',
      'time': 'Friday, 9:00 AM - 11:50 AM',
    },
    {
      'code': 'UNGS 2011',
      'title': 'Creative Thinking and Problem Solving',
      'section': 'Section 5',
      'time': 'Tue & Thu, 11:30 AM - 12:50 PM',
    },
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
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Text(
                  course['code']!.split(' ')[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                '${course['code']} - ${course['title']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${course['section']}\n${course['time']}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
