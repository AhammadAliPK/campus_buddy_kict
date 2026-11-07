import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart'; // NEW

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});
  
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // NEW: Pencil icon
            onPressed: () async {
              final editedCourse = await Navigator.push<Course>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCourseScreen(course: course),
                ),
              );

              // NEW: Null check handles the back button cancellation safely
              if (editedCourse != null) {
                // If saved, immediately pop the new course back to the Courses list
                if (context.mounted) Navigator.pop(context, editedCourse);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(course.icon, size: 48,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(course.name,
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('${course.creditHours} credit hours • ${course.day}'),
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