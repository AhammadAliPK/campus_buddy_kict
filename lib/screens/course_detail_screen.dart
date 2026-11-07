import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

/// Pops `true` when the course should be removed, or the edited [Course]
/// when it was changed. Back button = `null` = nothing changed.
class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  Future<void> _edit(BuildContext context) async {
    final edited = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => EditCourseScreen(course: course)),
    );
    if (edited == null || !context.mounted) return; // back = cancelled
    Navigator.pop(context, edited);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
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
            Row(children: [
              Icon(course.icon, size: 48,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(course.name,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ]),
            const SizedBox(height: 16),
            Text('${course.creditHours} credit hours · ${course.day}'),
            Text('${course.time} · ${course.venue}'),
            Text(course.instructor ?? 'TBA'),
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
