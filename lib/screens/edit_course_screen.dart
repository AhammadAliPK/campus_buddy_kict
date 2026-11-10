import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;
  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Using copyWith (or creating a new instance) to send back updated data
                final updatedCourse = Course(
                  widget.course.code,
                  _nameController.text, // The new name
                  widget.course.creditHours,
                  widget.course.day,
                  widget.course.icon,
                );
                Navigator.pop(context, updatedCourse);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
