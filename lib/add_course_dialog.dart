
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  // Form key and text controllers
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  // Day dropdown
  String _day = 'Monday';

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  // Credit hours slider
  int _creditHours = 3;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  // Validate the form
  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final course = Course(
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      creditHours: _creditHours,
      day: _day,
      icon: Icons.auto_stories,
      time: _timeCtrl.text.trim(),
      venue: _venueCtrl.text.trim(),
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
              // 1. Course code
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4311)',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';

                  if (t.isEmpty) {
                    return 'Code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // 2. Course name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Course name',
                ),
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) {
                    return 'Name is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              const SizedBox(height: 12),

              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 09:00)',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Time is required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (e.g. Lab 2)',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Venue is required' : null,
              ),

              // 3. Day dropdown
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                ),
                items: _days.map((d) {
                  return DropdownMenuItem<String>(
                    value: d,
                    child: Text(d),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      _day = v;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // 4. Credit hours slider
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
                      onChanged: (v) {
                        setState(() {
                          _creditHours = v.round();
                        });
                      },
                    ),
                  ),

                  Text('$_creditHours'),
                ],
              ),
            ],
          ),
        ),
      ),

      // Dialog buttons
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
