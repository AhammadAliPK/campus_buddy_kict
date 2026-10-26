import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; 
    for (final c in sampleCourses) { 
      totalCh = totalCh + c.creditHours; 
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_on),
            tooltip: 'Grid view',
            onPressed: () {}, 
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('${sampleCourses.length} courses | $totalCh credit hours'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: sampleCourses.length,
              itemBuilder: (context, index) {
                final course = sampleCourses[index];
                return ListTile(
                  tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(course.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  title: Text(course.code),
                  subtitle: Text('${course.name} ${course.creditHours} CH'),
                  trailing: Text(course.day),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${course.code} tapped')),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}