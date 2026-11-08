import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;
  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _venueCtrl;
  late TextEditingController _timeCtrl;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text boxes with the existing course data
    _nameCtrl = TextEditingController(text: widget.course.name);
    _venueCtrl = TextEditingController(text: widget.course.venue);
    _timeCtrl = TextEditingController(text: widget.course.time);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  void _save() {
    // Create a new Course with the updated values
    final updatedCourse = Course(
      widget.course.code,
      _nameCtrl.text.trim(),
      widget.course.creditHours,
      widget.course.day,
      _timeCtrl.text.trim(),
      _venueCtrl.text.trim(),
      widget.course.instructor,
      widget.course.icon,
      isFavorite: widget.course.isFavorite, // Keep the original star
      enrolled: widget.course.enrolled,     // Keep the original enrollment
    );
    
    // Send the updated course back to the previous screen
    Navigator.pop(context, updatedCourse); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Course Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _venueCtrl,
              decoration: const InputDecoration(labelText: 'Venue', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeCtrl,
              decoration: const InputDecoration(labelText: 'Time', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}