import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

// In-class exercise: show only this day. Set to null to show every day.
const String? _filterDay = null;

const _dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
};

// Works for 'Monday' and for 'Tuesday/Thursday' (uses the first day found).
int _dayRank(String day) {
  var rank = 8;
  _dayOrder.forEach((name, order) {
    if (day.contains(name) && order < rank) rank = order;
  });
  return rank;
}

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

    // Exercise: keep only one day. Homework 3: sort by day.
    final shown = sampleCourses
        .where((c) => _filterDay == null || c.day.contains(_filterDay!))
        .toList()
      ..sort((a, b) => _dayRank(a.day).compareTo(_dayRank(b.day)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
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
                  '${sampleCourses.length} courses · $totalCh credit hours'),
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
                          crossAxisCount: 2, // two cards per row
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
                                  Text(course.code,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(course.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
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
                              child: Icon(course.icon,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                            title: Text(course.code),
                            isThreeLine: true,
                            subtitle: Text(
                              '${course.name} · ${course.creditHours} CH\n'
                              '${course.day} ${course.time} · '
                              '${course.venue} · ${course.instructor ?? 'TBA'}',
                            ),
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
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
