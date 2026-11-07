import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

// Pops with: true  = remove this course
//            Course = the edited course
//            null   = nothing changed (back button)
class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.otherCodes,
  });

  final Course course;
  final List<String> otherCodes; // codes of the OTHER courses (duplicate guard)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              final edited = await Navigator.push<Course>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCourseScreen(
                    course: course,
                    otherCodes: otherCodes,
                  ),
                ),
              );
              // null = the user pressed back, so nothing changes
              if (edited != null && context.mounted) {
                Navigator.pop(context, edited);
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
            Row(children: [
              Icon(course.icon,
                  size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(course.name,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ]),
            const SizedBox(height: 16),
            Text('${course.chText} credit hours · ${course.day}'),
            const SizedBox(height: 4),
            Text('${course.time} · ${course.venue}'),
            const SizedBox(height: 4),
            Text('Lecturer: ${course.instructor ?? 'TBA'}'),
            const SizedBox(height: 8),
            Text(
              '${course.isFavorite ? 'Starred' : 'Not starred'} · '
              '${course.enrolled ? 'Enrolled' : 'Not enrolled'}',
            ),
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
