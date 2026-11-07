
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({
    super.key,
    required this.existingCodes,
  });

  final List<String> existingCodes;

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  // Form and text controllers
  final _formKey = GlobalKey<FormState>();

  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();
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

  // Clean up controllers
  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _instructorCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  // Validate form and return the new Course
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      Icons.auto_stories,
      _timeCtrl.text.trim(),
      _instructorCtrl.text.trim().isEmpty
          ? null
          : _instructorCtrl.text.trim(),
      _venueCtrl.text.trim(),
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
              // Course Code
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4311)',
                ),
                validator: (v) {
                  final t = v?.trim().toUpperCase() ?? '';

                  if (t.isEmpty) {
                    return 'Code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  if (widget.existingCodes.contains(t)) {
                    return 'Already added';
                  }

                  return null;
                },
              ),

              // Course Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Course name',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true)
                        ? 'Name is required'
                        : null,
              ),

              // Day dropdown
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                ),
                items: _days.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _day = v);
                  }
                },
              ),

              // Credit hours slider
              const SizedBox(height: 8),

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

              const SizedBox(height: 12),

              // Time
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 8.00 AM - 10.00 AM)',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true)
                        ? 'Time is required'
                        : null,
              ),

              // Instructor
              TextFormField(
                controller: _instructorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Instructor (optional)',
                ),
              ),

              // Venue
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (e.g. KICT Lab 1)',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true)
                        ? 'Venue is required'
                        : null,
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
