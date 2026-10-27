import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  
  // 1. NEW: State variable to keep track of the currently selected day
  String _selectedDay = 'Monday';

  // List of days to show in the chips bar
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours;
    }

    // 2. NEW: Filter courses dynamically based on _selectedDay instead of hardcoded 'Monday'
    final shown = sampleCourses.where((c) => c.day == _selectedDay).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.grid_on : Icons.list),
            tooltip: 'Toggle view',
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
              padding: const EdgeInsets.all(12),
              child: Text(
                '${sampleCourses.length} courses · $totalCh credit hours',
              ),
            ),
          ),
          
          // 3. NEW: Horizontal row of FilterChips to pick the day by tapping
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _days.map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedDay = day; // Updates selected day and triggers redraw
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text(
                      'No classes! Alhamdulillah :)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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
                                  Text(
                                    course.code,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          return ListTile(
                            leading: CircleAvatar(
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    child: Icon(course.icon,
        color: Theme.of(context).colorScheme.onPrimaryContainer),
  ),
  title: Text(course.code),
                            subtitle: Text(
    '${course.day.substring(0, 3)} ${course.time} · ${course.venue}\nInstructor: ${course.instructor ?? 'TBA'}',
  ),
  isThreeLine: true, // Needed so the two-line subtitle fits cleanly
  
  trailing: Text('${course.creditHours} CH'),
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