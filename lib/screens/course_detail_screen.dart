import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.course});
  final Course course;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCourse.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Wait for the edited course, check if cancelled (null)
              final editedCourse = await Navigator.push<Course>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditCourseScreen(course: _currentCourse),
                ),
              );

              // Update if not cancelled
              // Update if not cancelled
              if (editedCourse != null) {
                setState(() {
                  _currentCourse = editedCourse;
                });

                // NEW: Find the original course in the global list and replace it
                final index = sampleCourses.indexWhere(
                  (c) => c.code == editedCourse.code,
                );
                if (index != -1) {
                  sampleCourses[index] = editedCourse;
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _currentCourse.icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _currentCourse.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${_currentCourse.creditHours} credit hours \n${_currentCourse.day}',
            ),
            const SizedBox(height: 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove this course'),
                // Still pops true for deletion
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
