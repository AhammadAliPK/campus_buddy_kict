import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  final List<String> existingCodes;

  const AddCourseDialog({super.key, required this.existingCodes});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  String _day = 'Monday';
  int _creditHours = 3;

  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      _timeCtrl.text.trim(),
      _venueCtrl.text.trim(),
      Icons.auto_stories,
    );

    Navigator.pop(context, course);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  hintText: 'e.g. CSCI 4311',
                ),
                validator: (value) {
                  final code = value?.trim().toUpperCase() ?? '';

                  if (code.isEmpty) {
                    return 'Code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(code)) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  final alreadyExists = widget.existingCodes.any(
                    (existing) => existing.trim().toUpperCase() == code,
                  );

                  if (alreadyExists) {
                    return 'Already added';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  hintText: 'e.g. Mobile Application Development',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Class Time',
                  hintText: 'e.g. 10:00 AM - 12:00 PM',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Class time is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  hintText: 'e.g. Lab 3',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Venue is required';
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
                  return DropdownMenuItem<String>(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _day = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Credit hours'),
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
                  Text(
                    '$_creditHours',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
