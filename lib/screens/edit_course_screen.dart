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
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with the current course name
    _nameCtrl = TextEditingController(text: widget.course.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update the name while keeping the rest of the data intact
                    final updatedCourse = widget.course.copyWith(
                      name: _nameCtrl.text.trim(),
                    );
                    Navigator.pop(context, updatedCourse);
                  }
                },
                child: const Text('Save Changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}