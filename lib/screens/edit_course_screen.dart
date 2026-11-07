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

  late int _creditHours;
  late String _day;

  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController(text: widget.course.code);

    _nameController = TextEditingController(text: widget.course.name);

    _creditHours = widget.course.creditHours;
    _day = widget.course.day;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;

    final updatedCourse = widget.course.copyWith(
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      creditHours: _creditHours,
      day: _day,
    );

    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';

                  if (text.isEmpty) {
                    return 'Course code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$')
                      .hasMatch(text.toUpperCase())) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Course name is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _day = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('Credit Hours'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _creditHours = value.round();
                        });
                      },
                    ),
                  ),
                  Text('$_creditHours'),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCourse,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
