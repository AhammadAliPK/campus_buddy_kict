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
      totalCh += c.creditHours;
    }

    final shown = sampleCourses.where((c) => c.day == 'Monday').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Credit Hours'),
                  Text(
                    '$totalCh CH',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];

                      return Card(
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${course.code} tapped')),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(course.icon, size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  course.code,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(course.name, textAlign: TextAlign.center),
                                const SizedBox(height: 6),
                                Text(
                                  '${course.day.substring(0, 3)} ${course.time}',
                                  textAlign: TextAlign.center,
                                ),
                                Text(course.venue, textAlign: TextAlign.center),
                                Text(
                                  course.instructor ?? 'TBA',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
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
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course.icon,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name}\n'
                          '${course.day.substring(0, 3)} ${course.time} · '
                          '${course.venue}\n'
                          'Instructor: ${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        trailing: Text('${course.creditHours} CH'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${course.code} tapped')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
