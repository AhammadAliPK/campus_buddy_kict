import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _selectedDay = 'All'; // State variable for day filtering

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours;
    }

    // Smart filtering to handle multi-day strings like 'T-TH' and 'M-W'
    final shown = sampleCourses.where((c) {
      if (_selectedDay == 'All') return c.day != '';
      
      final dayUpper = c.day.toUpperCase();
      
      switch (_selectedDay) {
        case 'Mon':
          return dayUpper.contains('M'); // Matches 'M-W'
        case 'Tue':
          return dayUpper.startsWith('T') || dayUpper.contains('TUE'); // Matches 'T-TH'
        case 'Wed':
          return dayUpper.contains('W'); // Matches 'M-W' and 'WED'
        case 'Thu':
          return dayUpper.contains('TH'); // Matches 'T-TH'
        case 'Fri':
          return dayUpper.contains('F'); // Matches 'FRI'
        default:
          return true;
      }
    }).toList();

    const days = ['All', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

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
                '${sampleCourses.length} courses · $totalCh credit hours',
              ),
            ),
          ),
          
          // Row of FilterChips for selecting days
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: days.map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDay = day;
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
                ? const Center(child: Text('No classes found! Alhamdulillah :)'))
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(course.icon, size: 36),
                                    const SizedBox(height: 6),
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
                                    const SizedBox(height: 4),
                                    Text(
                                      '${course.day} · ${course.time}',
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.black54),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                              child: Icon(course.icon,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                            title: Text(course.code),
                            subtitle: Text(
                              '${course.name}\n${course.day} - ${course.time} - ${course.venue}\nInstructor: ${course.instructor ?? "TBA"}',
                            ),
                            isThreeLine: true,
                            trailing: Text('${course.creditHours} CH'),
                            onTap: () => ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                  content: Text('${course.code} tapped')),
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