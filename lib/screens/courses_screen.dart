import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';

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

    // Seperate copy of sample courses
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,

      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    // Enrolled count
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    // Filter courses based on day
    // final shown = _courses.where((course) => course.day == 'Monday' ).toList();
    final shown = _courses.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          // Add button
          IconButton(icon: const Icon(Icons.add), onPressed: _addCourse),

          // Grid button
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children:
            // SUMMARY CARD
            [
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${_courses.length} courses · $totalCh credit hours\nEnrolled: $enrolledCh CH',
                  ),
                ),
              ),

              Expanded(
                child: _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // two cards per row
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
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
                    : shown.isEmpty
                    ? const Center(
                        child: Text('No class today. Alhamdulillah :)'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          // No class
                          if (shown.isEmpty) {
                            return Text('No class today. Alhamdulillah :)');
                          }
                          // At least 1 class
                          else {
                            final course = shown[index];
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
                                '${course.name} · ${course.creditHours} CH · ${course.instructor ?? 'TBA'}',
                              ),

                              trailing: IconButton(
                                icon: Icon(
                                  course.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: course.isFavorite
                                      ? Colors.amber
                                      : null,
                                ),
                                onPressed: () => _toggleFavorite(index),
                              ),

                              onTap: () async {
                                final removed = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailScreen(
                                      course: _courses[index],
                                    ),
                                  ),
                                );
                                if (removed == true) {
                                  setState(() => _courses.removeAt(index));
                                }
                              },

                              tileColor: index.isOdd
                                  ? Colors.black.withValues(alpha: 0.03)
                                  : null,
                            );
                          }
                        },
                      ),
              ),
            ],
      ),
    );
  }
}
