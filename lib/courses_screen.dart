
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
    // Calculate total credit hours
    int totalCh = 0;

    for (final c in sampleCourses) {
      totalCh += c.creditHours;
    }

    // Filter courses to show Monday only
    final shown = sampleCourses
        .where((c) => c.day == 'Monday')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list),
            tooltip: 'Grid view',
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
                '${shown.length} courses · ${shown.fold(0, (sum, c) => sum + c.creditHours)} credit hours',
              ),
            ),
          ),

          // Course list or grid
          Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text('No classes! Alhamdulillah :)'),
                  )
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];

                          return Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(course.icon, size: 28),
                                    const SizedBox(height: 3),

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

                                    const SizedBox(height: 4),

                                    Text(
                                      '${course.day} ${course.time}',
                                      textAlign: TextAlign.center,
                                    ),

                                    Text(
                                      course.venue,
                                      textAlign: TextAlign.center,
                                    ),

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
                              '${course.day} ${course.time} · ${course.venue}',
                            ),

                            trailing: Text(
                              course.instructor ?? 'TBA',
                            ),

                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${course.code} tapped'),
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
