import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _creditController = TextEditingController();
  String? _day;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        _codeController.text.trim(),
        _nameController.text.trim(),
        num.parse(_creditController.text.trim()),
        _day!,
        Icons.book,
        'TBA',
        'TBA',
      );
      Navigator.pop(context, course);
    }
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
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Course code'),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Code is required';
                  }
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(value.trim())) {
                    return '4 letters and 4 digits, e.g. CSCI 4311';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
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
                  for (final d in weekDays)
                    DropdownMenuItem(value: d, child: Text(d)),
                ],
                onChanged: (v) => setState(() => _day = v),
                validator: (value) => value == null ? 'Pick a day' : null,
              ),
              TextFormField(
                controller: _creditController,
                decoration: const InputDecoration(labelText: 'Credit hours'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final ch = num.tryParse(value?.trim() ?? '');
                  if (ch == null || ch <= 0) {
                    return 'Enter a number, e.g. 3';
                  }
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
