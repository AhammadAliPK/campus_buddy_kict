import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _day = 'All';
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in sampleCourses) {
      // ← NEW
      totalCh = totalCh + c.creditHours; // ← NEW
    } // ← NEW
    final shown = _day == 'All'
        ? ([...sampleCourses]..sort(
            (a, b) => _days.indexOf(a.days.first) - _days.indexOf(b.days.first),
          ))
        : sampleCourses.where((c) => c.days.contains(_day)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () =>
                setState(() => _isGrid = !_isGrid), // D. wires this up
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final d in ['All', ..._days])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(d.substring(0, 3)),
                      selected: _day == d,
                      onSelected: (_) => setState(() => _day = d),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      return Card(
                        child: InkWell(
                          onTap: () => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                SnackBar(
                                  content: Text('${course.code} tapped'),
                                ),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(course.icon, size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  course.code,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${course.creditHours} CH · ${course.days.map((d) => d.substring(0, 3)).join(', ')}',
                                ),
                                Text('${course.time} · ${course.venue}'),
                                Text(course.instructor ?? 'TBA'),
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
                        isThreeLine: true,
                        subtitle: Text(
                          '${course.name} · ${course.creditHours} CH\n'
                          '${course.days.map((d) => d.substring(0, 3)).join(', ')} '
                          '${course.time} · ${course.venue}\n'
                          '${course.instructor ?? 'TBA'}',
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
