import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours.toInt();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_on),
            tooltip: 'Grid View',
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
              child: Text(
                '${sampleCourses.length} courses · $totalCh credit hours',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: sampleCourses.length,
              itemBuilder: (context, index) {
                print('Building row $index');
                final course = sampleCourses[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      course.icon,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    course.code,
                    style: TextStyle(
                      color: index.isOdd
                          ? Colors.black.withValues(alpha: 0.3)
                          : null,
                    ),
                  ),
                  subtitle: Text('${course.name} · ${course.creditHours} CH'),
                  trailing: Text(course.day),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${course.code} opened')),
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
