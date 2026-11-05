import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart'; // ← NEW

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  // ← NEW (homework 2 + 3): open the edit form, wait for its answer
  Future<void> _edit(BuildContext context) async {
    final edited = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => EditCourseScreen(course: course)),
    );
    // back button = null = cancelled → nothing changes
    if (edited == null || !context.mounted) return;
    Navigator.pop(context, edited); // hand the edited course to the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            // ← NEW (homework 2)
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => _edit(context),
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
            Text('${course.creditHours} credit hours · ${course.day}'),
            const SizedBox(height: 8),
            Text('${course.time} · ${course.venue}'), // ← NEW
            const SizedBox(height: 8),
            Text('Instructor: ${course.instructor ?? 'TBA'}'), // ← NEW
            const SizedBox(height: 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove this course'),
                onPressed: () => Navigator.pop(context, true), // the answer
              ),
            ),
          ],
        ),
      ),
    );
  }
}
