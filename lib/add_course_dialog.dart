
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

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

  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();

  String _day = 'Monday';
  int _creditHours = 3;

  static const _days = [
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
    _instructorCtrl.dispose();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      Icons.auto_stories,
      _timeCtrl.text.trim().isEmpty ? 'TBA' : _timeCtrl.text.trim(),
      _venueCtrl.text.trim().isEmpty ? 'TBA' : _venueCtrl.text.trim(),
      _instructorCtrl.text.trim().isEmpty
          ? null
          : _instructorCtrl.text.trim(),
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
              // Course code
              TextFormField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4311)',
                ),
                validator: (v) {
                  final code = v?.trim() ?? '';

                  if (code.isEmpty) {
                    return 'Code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$')
                      .hasMatch(code.toUpperCase())) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  final alreadyExists = widget.existingCodes.any(
                    (existing) =>
                        existing.replaceAll(' ', '').toUpperCase() ==
                        code.replaceAll(' ', '').toUpperCase(),
                  );

                  if (alreadyExists) {
                    return 'Already added';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Course name
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

              const SizedBox(height: 12),

              // Day dropdown
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                ),
                items: _days
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(d),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _day = v);
                  }
                },
              ),

              const SizedBox(height: 12),

              // Credit hours slider
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

              const SizedBox(height: 8),

              // Time
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (optional)',
                  hintText: '09:00 - 10:30',
                ),
              ),

              const SizedBox(height: 12),

              // Venue
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (optional)',
                  hintText: 'LT A',
                ),
              ),

              const SizedBox(height: 12),

              // Instructor
              TextFormField(
                controller: _instructorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Instructor (optional)',
                ),
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

        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
