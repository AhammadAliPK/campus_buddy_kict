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

  late String _code;
  late String _name;
  late int _creditHours;
  late String _day;

  @override
  void initState() {
    super.initState();

    _code = widget.course.code;
    _name = widget.course.name;
    _creditHours = widget.course.creditHours;
    _day = widget.course.day;
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final updatedCourse = widget.course.copyWith(
      code: _code,
      name: _name,
      creditHours: _creditHours,
      day: _day,
    );

    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _code,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a course code';
                  }
                  return null;
                },
                onSaved: (value) => _code = value!.trim(),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!.trim(),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: _creditHours.toString(),
                decoration: const InputDecoration(
                  labelText: 'Credit Hours',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final credits = int.tryParse(value?.trim() ?? '');

                  if (credits == null || credits <= 0) {
                    return 'Please enter valid credit hours';
                  }
                  return null;
                },
                onSaved: (value) {
                  _creditHours = int.parse(value!.trim());
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a day';
                  }
                  return null;
                },
                onSaved: (value) => _day = value!.trim(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveCourse,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}