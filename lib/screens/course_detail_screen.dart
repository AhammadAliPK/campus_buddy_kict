
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailScreen> createState() =>
      _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
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

              if (updatedCourse != null) {
                setState(() {
                  course = updatedCourse;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.code,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              course.name,
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 24),

            Text('Credit Hours: ${course.creditHours}'),
            const SizedBox(height: 12),

            Text('Day: ${course.day}'),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Remove Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
