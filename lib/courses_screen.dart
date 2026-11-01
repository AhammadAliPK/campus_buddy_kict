
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

    // Week 4 in-class exercise: filter Monday courses
    final shown = sampleCourses
        .where((c) => c.day == 'Monday')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(
              _isGrid ? Icons.list : Icons.grid_on,
            ),
            tooltip: _isGrid
                ? 'Switch to List View'
                : 'Switch to Grid View',
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
          // Summary card
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${sampleCourses.length} courses · '
                '$totalCh credit hours',
              ),
            ),
          ),

          // Course List / Grid
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: sampleCourses.length,
                    itemBuilder: (context, index) {
                      final course = sampleCourses[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(course.icon, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                course.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${course.day} ${course.time}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                course.venue,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Instructor: '
                                '${course.instructor ?? 'TBA'}',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )

                // Show message if no Monday courses
                : shown.isEmpty
                    ? const Center(
                        child: Text(
                          'No classes! Alhamdulillah :)',
                        ),
                      )

                    // List view
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];

                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(
                                    alpha: 0.03,
                                  )
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
                            title: Text(
                              '${course.code} - ${course.name}',
                            ),
                            subtitle: Text(
                              '${course.day} ${course.time} '
                              '· ${course.venue}\n'
                              'Instructor: '
                              '${course.instructor ?? 'TBA'}',
                            ),
                            isThreeLine: true,
                            trailing: Text(
                              '${course.creditHours} CH',
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${course.code} tapped',
                                  ),
                                ),
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
