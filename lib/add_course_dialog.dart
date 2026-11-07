
import 'package:flutter/material.dart';
import 'models/course.dart';

class AddCourseDialog extends StatefulWidget {
  final List<String> existingCodes;

  const AddCourseDialog({
    super.key,
    required this.existingCodes,
  });

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedDay = 'Monday';
  int _creditHours = 3;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Course code
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  hintText: 'e.g. CSCI 4311',
                ),
                // study validatorrrr
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a course code';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid code (e.g. CSCI 4311)';
                  }

                  if (widget.existingCodes.any(
                    (code) => code.toUpperCase() == value.trim().toUpperCase(),
                  )) {
                    return 'This course has already been added';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Course name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a course name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Day dropdown
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: const InputDecoration(
                  labelText: 'Day',
                ),
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                ].map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDay = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Credit hours slider
              Text('Credit Hours: $_creditHours'),
              Slider(
                value: _creditHours.toDouble(),
                min: 1,
                max: 4,
                divisions: 3,
                label: '$_creditHours',
                onChanged: (value) {
                  setState(() {
                    _creditHours = value.toInt();
                  });
                },
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCourse = Course(
                _codeController.text.trim(),
                _nameController.text.trim(),
                _creditHours,
                _selectedDay,
                Icons.book,
              );

              Navigator.pop(context, newCourse);
            }
          },
          child: const Text('Add Course'),
        ),
      ],
    );
  }
}
