import 'package:campus_buddy_kict/screens/edit_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({
    super.key, 
    required this.course,
    required this.existingCodes, // Add existingCodes parameter
  });

  final Course course;
  final List<String> existingCodes; // List of all enrolled course codes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.code)),
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
                // NEW ICON BUTTON CODE HERE
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedCourse = await Navigator.push<Course>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCourseScreen(
                          course: course,
                          existingCodes: existingCodes,
                        ),
                      ),
                    );

                    // If the user saved changes, pop back to the previous screen 
                    // and pass the updated course object
                    if (updatedCourse != null && context.mounted) {
                      Navigator.pop(context, updatedCourse);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('${course.creditHours} credit hours · ${course.day}'),
            Text('${course.time} · ${course.venue}'),
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