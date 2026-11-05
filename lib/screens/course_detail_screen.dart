import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course}); // must be given a course

  final Course course;                              // the course this page shows

  @override
  Widget build(BuildContext context) {
    return Scaffold(                                // own page → automatic ← back arrow
      appBar: AppBar(title: Text(course.code)),
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
            const SizedBox(height: 24),
            const Spacer(),                         // pushes the button to the bottom
            SizedBox(
              width: double.infinity,               // full-width button
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove this course'),
                onPressed: () => Navigator.pop(context, true), // close + answer "true"
              ),
            ),
          ],
        ),
      ),
    );
  }
}