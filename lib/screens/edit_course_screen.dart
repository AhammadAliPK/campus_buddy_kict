
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({
    super.key,
    required this.course,
  });

  @override
  State<EditCourseScreen> createState() =>
      _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController dayController;

  late double creditHours;

  @override
  void initState() {
    super.initState();

    codeController =
        TextEditingController(text: widget.course.code);

    nameController =
        TextEditingController(text: widget.course.name);

    dayController =
        TextEditingController(text: widget.course.day);

    creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    dayController.dispose();
    super.dispose();
  }

  void saveCourse() {
    if (codeController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        dayController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields.'),
        ),
      );
      return;
    }

    final updatedCourse = widget.course.copyWith(
      code: codeController.text.trim(),
      name: nameController.text.trim(),
      day: dayController.text.trim(),
      creditHours: creditHours,
    );

    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Course Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: dayController,
              decoration: const InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Credit Hours: $creditHours',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Slider(
              value: creditHours,
              min: 0.5,
              max: 6,
              divisions: 11,
              label: creditHours.toString(),
              onChanged: (value) {
                setState(() {
                  creditHours = value;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: saveCourse,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
