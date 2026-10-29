import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';   // ← NEW

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  String _day = 'Monday'; // NEW: current choice
  static const _days = [ // NEW: the options
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  int _creditHours = 3;   // ← NEW: the slider's current value

  final _formKey = GlobalKey<FormState>();     // ← NEW: the form's name tag  
  final _codeCtrl = TextEditingController();   // ← NEW: remembers the typing
  final _nameCtrl = TextEditingController();   // ← NEW

  @override  
  void dispose() {                             // ← NEW: clean up on close    
    _codeCtrl.dispose();    
    _nameCtrl.dispose();
    super.dispose();  
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final course = Course( // NEW: pack the answers
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      Icons.auto_stories,
    );
    Navigator.pop(context, course); // CHANGED: close AND answer
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView( // NEW
          child: Column( // NEW: one field per row
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField( // the code field, unchanged
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
                  return null;
                },
              ),
              TextFormField( // NEW: the name field
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Course name',
                ),
                validator: (v) => (v?.trim().isEmpty ?? true) 
                ? 'Name is required' 
                : null,
              ),
              DropdownButtonFormField<String>( // NEW
                initialValue: _day,
                items: _days
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
              const SizedBox(height: 8), // NEW: a little air
              Row( // NEW: label + slider + number
                children: [
                  const Text('Credit hours'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (v) => setState(() => _creditHours = v.round()),
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
          onPressed: () => Navigator.pop(context), // close the popup
          child: const Text('Cancel'),
        ),
        FilledButton( // NEW: the check-and-add button
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
