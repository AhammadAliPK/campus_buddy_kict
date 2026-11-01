import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

/// A popup holding a form. Pops a [Course] when saved, or null if cancelled.
class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  static const _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Mon & Wed',
    'Tue & Thu',
  ];

  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _creditCtrl = TextEditingController();
  String? _day;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _creditCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        Course(
          _codeCtrl.text.trim().toUpperCase(),
          _nameCtrl.text.trim(),
          double.parse(_creditCtrl.text.trim()),
          _day!,
          'TBA',
          'TBA',
          Icons.book,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Course code'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Code is required';
                  }
                  if (!RegExp(r'^[A-Za-z]{4}\s?\d{4}$')
                      .hasMatch(value.trim())) {
                    return 'Use 4 letters + 4 digits, e.g. CSCI 4311';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(labelText: 'Day'),
                items: [
                  for (final d in _days)
                    DropdownMenuItem(value: d, child: Text(d)),
                ],
                onChanged: (v) => setState(() => _day = v),
                validator: (v) => v == null ? 'Pick a day' : null,
              ),
              TextFormField(
                controller: _creditCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Credit hours'),
                validator: (value) {
                  final ch = double.tryParse(value?.trim() ?? '');
                  if (ch == null) return 'Enter a number, e.g. 3';
                  if (ch <= 0 || ch > 6) return 'Between 0.5 and 6';
                  return null;
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
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
