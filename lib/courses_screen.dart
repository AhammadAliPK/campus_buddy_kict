import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart'; // ← NEW this week
import 'package:campus_buddy_kict/add_course_dialog.dart'; // ← NEW

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  bool _isGrid = false; // ← NEW

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index) {
    // ← NEW: same shape as the star
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(), // ← NEW (exercise)
      ),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in _courses) {
      // ← NEW
      totalCh = totalCh + c.creditHours; // ← NEW
    } // ← NEW
    final enrolledCh =
        _courses // ← NEW
            .where((c) => c.enrolled)
            .fold<int>(0, (sum, c) => sum + c.creditHours);
    const dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    }; // ← NEW
    final sorted =
        [..._courses] // ← CHANGED: was sampleCourses
          ..sort(
            (a, b) => (dayOrder[a.day] ?? 8).compareTo(dayOrder[b.day] ?? 8),
          );
    final shown = sorted.where((c) => c.day == 'Monday').toList(); // ← NEW
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            // ← NEW: opens the Add popup
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
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
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH', // ← NEW: the second line
              ),
            ),
          ),
          Expanded(
            child:
                _isGrid // ← CHANGED
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // two cards per row
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final course = sorted[index];

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
                : shown
                      .isEmpty // ← NEW
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shown.length, // ← CHANGED
                    itemBuilder: (context, index) {
                      final course = shown[index]; // ← CHANGED
                      // shown is sorted + filtered, so find this course's
                      // real position in _courses before changing it
                      final i = _courses.indexOf(course);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course
                                    .enrolled // ← CHANGED: was course.icon
                                ? Icons.check_circle
                                : course.icon,
                            color:
                                course
                                    .enrolled // ← CHANGED
                                ? Colors.green
                                : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.creditHours} CH\n'
                          '${course.day.substring(0, 3)} ${course.time.split('–').first} · ${course.venue} · ${course.instructor ?? 'TBA'}', // ← CHANGED: instructor moved here
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          // ← CHANGED: was Text(course.instructor ?? 'TBA')
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(i),
                        ),
                        onTap: () => _toggleEnrolled(i), // ← CHANGED
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
