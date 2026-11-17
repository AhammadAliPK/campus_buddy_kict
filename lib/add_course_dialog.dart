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

  String _day = 'Monday';
  double _creditHours = 3.0;

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
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final course = Course(
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      creditHours: _creditHours,
      day: _day,
      time: 'Time not specified',
      venue: 'Venue not specified',
      instructor: null,
      icon: Icons.auto_stories,
    );

    Navigator.pop(context, course);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Course code',
                    hintText: 'e.g. CSCI 4311',
                    prefixIcon: Icon(Icons.code),
                  ),
                  validator: (value) {
                    final code =
                        (value ?? '').trim().toUpperCase();

                    if (code.isEmpty) {
                      return 'Code is required';
                    }

                    if (!RegExp(r'^[A-Z]{4}\s?\d{4}$')
                        .hasMatch(code)) {
                      return 'Use 4 letters and 4 digits';
                    }

                    final normalizedCode =
                        code.replaceAll(' ', '');

                    final duplicate = widget.existingCodes.any(
                      (existing) =>
                          existing.replaceAll(' ', '').toUpperCase() ==
                          normalizedCode,
                    );

                    if (duplicate) {
                      return 'Already added';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Course name',
                    prefixIcon: Icon(Icons.menu_book),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _day,
                  decoration: const InputDecoration(
                    labelText: 'Day',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: _days.map((day) {
                    return DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _day = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Credit hours'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        min: 0.5,
                        max: 4.0,
                        divisions: 7,
                        label: _creditHours.toStringAsFixed(1),
                        value: _creditHours,
                        onChanged: (value) {
                          setState(() {
                            _creditHours = value;
                          });
                        },
                      ),
                    ),
                    Text(_creditHours.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
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