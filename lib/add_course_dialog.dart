import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  final List<String> existingCodes;

  const AddCourseDialog({super.key, required this.existingCodes});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>(); // the form's name tag
  final _codeCtrl = TextEditingController(); // remembers the typing
  final _nameCtrl = TextEditingController();
  String _day = 'Monday';
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  int _creditHours = 3;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // 'csci 4311' and 'CSCI4311' count as the same code
  String _normalize(String s) => s.replaceAll(' ', '').toUpperCase();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      'TBA', // time and venue are not asked in this popup
      'TBA',
      Icons.auto_stories,
    );
    Navigator.pop(context, course); // close AND answer
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
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }
                  // Exercise: duplicate guard
                  final existing =
                      widget.existingCodes.map(_normalize).toList();
                  if (existing.contains(_normalize(t))) {
                    return 'Already added';
                  }
                  return null; // null means "this input is fine"
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: _day,
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
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
                      onChanged: (v) =>
                          setState(() => _creditHours = v.round()),
                    ),
                  ),
                  Text('$_creditHours'),
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
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
