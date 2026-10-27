import 'package:campus_buddy_kict/models/course.dart';
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
    final dayValues = {'M-W': 1, 'T-TH': 2, 'FRI': 5};

    final sortedCourses = sampleCourses.toList();
    sortedCourses.sort(
      (a, b) => (dayValues[a.day] ?? 8).compareTo(dayValues[b.day] ?? 8),
    );

    int totalCh = 0;
    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours;
    }

    final shown = sampleCourses
        .where((c) => c.day == 'Monday')
        .toList(); // ← NEW

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list), // ← CHANGED
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid), // ← CHANGED
          ),
        ],
      ),
      body: Column(
        // ← CHANGED
        children: [
          Card(
            // ← NEW
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${sortedCourses.length} courses · $totalCh credit hours',
              ),
            ),
          ),
          Expanded(
            child: sortedCourses.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: sortedCourses.length,
                    itemBuilder: (context, index) {
                      final course = sortedCourses[index];

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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sortedCourses.length,
                    itemBuilder: (context, index) {
                      final course = sortedCourses[index];

                      return ListTile(
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
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        subtitle: Text(
                          '${course.day} ${course.time} · ${course.venue}',
                        ),
                        trailing: Text(course.instructor ?? 'TBA'),
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
