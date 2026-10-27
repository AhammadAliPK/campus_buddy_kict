import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

/// Day name -> weekday number, used to sort the timetable.
const Map<String, int> _dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
};

/// Day name -> short name, used in the row subtitle ('Mon 09:00 · LT A').
const Map<String, String> _dayShort = {
  'Monday': 'Mon',
  'Tuesday': 'Tue',
  'Wednesday': 'Wed',
  'Thursday': 'Thu',
  'Friday': 'Fri',
  'Saturday': 'Sat',
  'Sunday': 'Sun',
};

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false; // -- NEW
  String? _selectedDay; // null = show every day

  @override
  Widget build(BuildContext context) {
    // Every day that actually has a class, in timetable order.
    final days = sampleCourses.map((c) => c.day).toSet().toList()
      ..sort((a, b) => (_dayOrder[a] ?? 99).compareTo(_dayOrder[b] ?? 99));

    // 1. keep only the chosen day (all when nothing is chosen)
    final shown = sampleCourses
        .where((c) => _selectedDay == null || c.day == _selectedDay)
        .toList();

    // 3. sort by day, then by start time
    shown.sort((a, b) {
      final byDay = (_dayOrder[a.day] ?? 99).compareTo(_dayOrder[b.day] ?? 99);
      return byDay != 0 ? byDay : a.time.compareTo(b.time);
    });

    int totalCh = 0;
    for (final c in shown) {
      totalCh = totalCh + c.creditHours;
    }

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
                '${shown.length} courses · $totalCh credit hours',
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final day in ['All', ...days])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(day),
                      selected:
                          (_selectedDay ?? 'All') == day,
                      onSelected: (_) => setState(
                          () => _selectedDay = day == 'All' ? null : day),
                    ),
                  ),
              ],
            ),
          ),
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
                                  Text(
                                    course.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_dayShort[course.day]} ${course.time}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
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
                              '${_dayShort[course.day]} ${course.time} · '
                              '${course.venue} · ${course.instructor ?? 'TBA'}',
                            ),
                            isThreeLine: true,
                            trailing: Text('${course.creditHours} CH'),
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
