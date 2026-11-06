
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _creditController;
  late final TextEditingController _dayController;

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController(
      text: widget.course.code,
    );
    _nameController = TextEditingController(
      text: widget.course.name,
    );
    _creditController = TextEditingController(
      text: widget.course.creditHours.toString(),
    );
    _dayController = TextEditingController(
      text: widget.course.day,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _creditController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final updatedCourse = Course(
        _codeController.text.trim(),
        _nameController.text.trim(),
        int.parse(_creditController.text.trim()),
        _dayController.text.trim(),
        widget.course.icon,
        isFavorite: widget.course.isFavorite,
      );

      Navigator.pop(context, updatedCourse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Course Code',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter course code';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter course name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _creditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Credit Hours',
              ),
              validator: (value) {
                final number = int.tryParse(value ?? '');
                if (number == null || number <= 0) {
                  return 'Enter valid credit hours';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dayController,
              decoration: const InputDecoration(
                labelText: 'Day',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a day';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCourse,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
