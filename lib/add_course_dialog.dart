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
  
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  String _day = 'Monday';
  int _creditHours = 3;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
  if (!_formKey.currentState!.validate()) return;

  final newCourse = Course(
    _codeCtrl.text.trim(),
    _nameCtrl.text.trim(),
    _creditHours,
    _day,
    Icons.menu_book,
    'TBA',
    'TBA',
    null,
  );

  Navigator.pop(context, newCourse);
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

                  final normalizedCode = t.replaceAll(' ', '');

                  if (widget.existingCodes.any(
                    (code) =>
                        code.toUpperCase().replaceAll(' ', '') == normalizedCode,
                  )) {
                    return 'Already added';
                  }

                  return null;
                },
              ),

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

              DropdownButtonFormField<String>(
                value: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                ),
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                    .map(
                      (day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _day = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              Text('Credit Hours: $_creditHours'),

              Slider(
                value: _creditHours.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_creditHours',
                onChanged: (value) {
                  setState(() {
                    _creditHours = value.round();
                  });
                },
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