
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _creditController;
  late TextEditingController _dayController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.name);
    _creditController = TextEditingController(
      text: widget.course.creditHours.toString(),
    );
    _dayController = TextEditingController(text: widget.course.day);
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
      final editedCourse = widget.course.copyWith(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        creditHours: int.parse(_creditController.text.trim()),
        day: _dayController.text.trim(),
      );

      Navigator.pop(context, editedCourse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter course code'
                        : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter course name'
                        : null,
              ),
              TextFormField(
                controller: _creditController,
                decoration: const InputDecoration(labelText: 'Credit Hours'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    int.tryParse(value ?? '') == null
                        ? 'Enter valid credit hours'
                        : null,
              ),
              TextFormField(
                controller: _dayController,
                decoration: const InputDecoration(labelText: 'Day'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter day'
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCourse,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
