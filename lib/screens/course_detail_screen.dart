import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});
  
  final Course course; // Data goes in through here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push<Course>(
                context,
                MaterialPageRoute(builder: (context) => EditCourseScreen(course: course)),
              );
              
              // Task 3: Only pass it back to the main list if they actually saved (not null)
              if (updated != null) {
                Navigator.pop(context, updated); 
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
                Icon(course.icon, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(course.name, style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Using .join() since your days variable is a list from the previous homework
            Text('${course.creditHours} credit hours · ${course.days.join(", ")}'), 
            const SizedBox(height: 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove this course'),
                // This hands the answer "true" back to the main screen
                onPressed: () => Navigator.pop(context, true), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}