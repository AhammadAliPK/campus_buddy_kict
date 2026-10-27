
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

    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours;
    }
    final shown = sampleCourses
    .where((c) => c.day == 'Monday')
    .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
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
              ),
            ),
          ),
          Expanded(
            child: _isGrid
      ? GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: shown.length,
          itemBuilder: (context, index) {
            final course = shown[index];

            return Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(course.icon, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      course.code,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      course.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      : shown.isEmpty
          ? const Center(
              child: Text('No classes! Alhamdulillah :)'),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: shown.length,
              itemBuilder: (context, index) {
                final course = shown[index];

                return ListTile(
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
                    '${course.day.substring(0, 3)} ${course.time} · ${course.venue}\n'
  '${course.instructor ?? 'TBA'}',
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
