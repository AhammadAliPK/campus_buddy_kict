import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Day order for sorting (uses the first 3 letters of Course.day)
const _dayOrder = {'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5};

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    // Sorted copy: by day, then by course code
    final List<Course> courses = [...sampleCourses]
      ..sort((a, b) {
        final byDay = (_dayOrder[a.day.substring(0, 3)] ?? 9)
            .compareTo(_dayOrder[b.day.substring(0, 3)] ?? 9);
        return byDay != 0 ? byDay : a.code.compareTo(b.code);
      });

    double totalCh = 0;
    for (final c in courses) {
      totalCh = totalCh + c.creditHours;
    }
    final totalText =
        totalCh % 1 == 0 ? totalCh.toInt().toString() : totalCh.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Switch view',
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
              child: Text('${courses.length} courses · $totalText credit hours'),
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
                      childAspectRatio: 1.2,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(course.icon, size: 40),
                              const SizedBox(height: 8),
                              Text(course.code,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        isThreeLine: true,
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(course.icon,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.chText} CH\n'
                          '${course.day} ${course.time} · ${course.venue}\n'
                          'Lecturer: ${course.instructor ?? 'TBA'}',
                        ),
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
