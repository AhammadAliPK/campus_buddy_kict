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
      totalCh = totalCh + c.creditHours.toInt();
    }

    const dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    final shown = sampleCourses.toList();

    shown.sort((a,b) => (dayOrder[a.day] ?? 8).compareTo(dayOrder[b.day] ?? 8));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid View',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ), //teach top button to flip memory
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
            child: shown.isEmpty
                ? const Center(child: Text('No courses available'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
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
                                course.code ?? 'TBA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                course.name ?? 'TBA',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8), // ADD

                              Text(
                                // ADD: Hari dan masa.
                                '${course.day.substring(0, 3)} ${course.time}',
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                // ADD: Venue.
                                course.venue,
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                // ADD: Instructor, atau TBA jika tiada.
                                course.instructor ?? 'TBA',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          '${course.code}',
                          style: TextStyle(
                            color: index.isOdd
                                ? Colors.black.withValues(alpha: 0.3)
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          '${course.day.substring(0,3)} · ${course.time} · ${course.venue}\n · ${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
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
