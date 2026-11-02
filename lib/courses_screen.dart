import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  // The toggles look the course up in _courses, so they stay correct
  // even when the screen shows a filtered list.
  void _toggleFavorite(Course course) {
    final i = _courses.indexOf(course);
    setState(() {
      _courses[i] = _courses[i].copyWith(isFavorite: !_courses[i].isFavorite);
    });
  }

  void _toggleEnrolled(Course course) {
    final i = _courses.indexOf(course);
    setState(() {
      _courses[i] = _courses[i].copyWith(enrolled: !_courses[i].enrolled);
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return; // the user cancelled
    setState(() => _courses.add(course));
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    // Week 4 exercise: show only Monday's courses
    // final shown =
    //     _courses.where((c) => c.day.contains('Monday')).toList();
    final shown = _courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
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
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
                textAlign: TextAlign.center,
              ),
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
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          return Card(
                            child: InkWell(
                              onTap: () => _toggleEnrolled(course),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      course.enrolled
                                          ? Icons.check_circle
                                          : course.icon,
                                      size: 40,
                                      color:
                                          course.enrolled ? Colors.green : null,
                                    ),
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
                                course.enrolled
                                    ? Icons.check_circle
                                    : course.icon,
                                color: course.enrolled
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                              ),
                            ),
                            title: Text(course.code),
                            subtitle: Text(
                                '${course.name} · ${course.creditHours} CH\n'
                                '${course.day} ${course.time} · ${course.venue}\n'
                                '${course.instructor ?? 'TBA'}'),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () => _toggleFavorite(course),
                            ),
                            onTap: () => _toggleEnrolled(course),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
