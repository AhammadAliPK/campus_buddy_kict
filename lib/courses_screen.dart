import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;

  // "Which day am I free?" — null shows every course.
  String? _dayFilter;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  // 0.5 -> "0.5", 3.0 -> "3"
  String _ch(double ch) => ch == ch.truncate() ? '${ch.toInt()}' : '$ch';

  @override
  Widget build(BuildContext context) {
    double totalCh = 0;
    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours;
    }

    final dayFilter = _dayFilter;
    final shown = dayFilter == null
        ? sampleCourses
        : sampleCourses.where((c) => c.day.contains(dayFilter)).toList();

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
                  '${sampleCourses.length} courses · ${_ch(totalCh)} credit hours'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _dayFilter == null,
                  onSelected: (_) => setState(() => _dayFilter = null),
                ),
                for (final day in _days) ...[
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(day),
                    selected: _dayFilter == day,
                    onSelected: (_) => setState(() => _dayFilter = day),
                  ),
                ],
              ],
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
                            subtitle: Text(
                                '${course.name}\n'
                                '${course.day} · ${course.time} · ${course.venue}\n'
                                'Instructor: ${course.instructor ?? 'TBA'}'),
                            isThreeLine: true,
                            trailing: Text('${_ch(course.creditHours)} CH'),
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
