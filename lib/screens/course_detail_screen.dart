
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'edit_course_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Course',
            onPressed: () async {
              final updatedCourse = await Navigator.push<Course>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditCourseScreen(course: course),
                ),
              );

              if (!context.mounted) return;

              if (updatedCourse != null) {
                Navigator.pop(context, updatedCourse);
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
                  course.icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    course.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${course.creditHours} credit hours · ${course.day}',
            ),
            const SizedBox(height: 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove this course'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
