
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          // Edit course button
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit course',
            onPressed: () async {
              final editedCourse = await Navigator.push<Course>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCourseScreen(course: course),
                ),
              );

              // Only return if the user saved the changes.
              if (editedCourse != null && context.mounted) {
                Navigator.pop(context, editedCourse);
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
            // Course heading
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

            const SizedBox(height: 24),

            // Course information
            Text('${course.creditHours} credit hours'),
            const SizedBox(height: 12),

            Text('Day: ${course.day}'),
            const SizedBox(height: 12),

            Text('Time: ${course.time}'),
            const SizedBox(height: 12),

            Text('Instructor: ${course.instructor ?? 'Not assigned'}'),
            const SizedBox(height: 12),

            Text('Venue: ${course.venue}'),

            const Spacer(),

            // Remove course button
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
