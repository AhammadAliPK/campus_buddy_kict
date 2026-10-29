import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  // This key is used to check if the form is filled out correctly
  final _formKey = GlobalKey<FormState>();

  // Text controllers to grab what the user types
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _day = 'Monday'; 
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  int _creditHours = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Course'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Course Code (e.g. CSCI 4311)'),
                validator: (value) {
                  final t = value?.trim() ?? '';
                  if (t.isEmpty) return 'Code is required';
                  // This pattern means: exactly 4 letters, optional space, exactly 4 numbers
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format must be like CSCI 4311';
                  }
                  return null; // Null means it passed validation!
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
              ),
              
              // --- NEW: THE DROPDOWN (Step 11) ---
              DropdownButtonFormField<String>(
                initialValue: _day,
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
              
              // --- NEW: THE SLIDER (Step 12) ---
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Credit hours'),
                  Expanded(
                    child: Slider(
                      min: 1, max: 4, divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (v) => setState(() => _creditHours = v.round()),
                    ),
                  ),
                  Text('$_creditHours'),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancels and closes the popup
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCourse = Course(
                _codeCtrl.text.toUpperCase().trim(),
                _nameCtrl.text.trim().isEmpty ? 'New Subject' : _nameCtrl.text.trim(),
                _creditHours, // <-- CHANGED: Uses the slider value
                [_day],       // <-- CHANGED: Uses the dropdown value
                Icons.auto_stories, // Changed to a book icon
                'TBA', 'TBA', 'TBA',
              );
              Navigator.pop(context, newCourse);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}