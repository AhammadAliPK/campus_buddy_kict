
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;

    for (final course in sampleCourses) {
      totalCh += course.creditHours;
    }

    final shown = sampleCourses;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      
body: Column(
  children: [
    Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '${sampleCourses.length} courses · $totalCh credit hours',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    ),
    
Expanded(
  child: shown.isEmpty
      ? const Center(
          child: Text('No classes! Alhamdulillah :)'),
        )
      : _isGrid
      ? GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: shown.length,
          itemBuilder: (context, index) {
            final course = shown[index];

            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(course.icon, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    course.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      course.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        )
      : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: shown.length,
          itemBuilder: (context, index) {
            final course = shown[index];

            return ListTile(
              tileColor: index.isOdd
                  ? Colors.black.withValues(alpha: 0.03)
                  : null,
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  course.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),
              title: Text(course.code),
              subtitle: Text(
                '${course.name} · ${course.creditHours} CH',
              ),
              trailing: Text(course.day),
              onTap: () =>
                  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${course.code} tapped'),
                ),
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