import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>(); //  the form's name tag
  final _codeCtrl = TextEditingController(); //  remembers the typing
  final _nameCtrl = TextEditingController();

  String _day = 'Monday'; // NEW: current choice
  static const _days = [  // NEW: the options
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
  ];

  int _creditHours = 3; // the slider's current value
  @override
  void dispose() {
    _codeCtrl.dispose(); // clean up on close
    _nameCtrl.dispose();
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
      'TBA',   // Default venue
      'TBA',   // CHANGED: Pass 'TBA' instead of null to prevent the crash
    );
    
    Navigator.pop(context, course);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView( // NEW
          child: Column( // one field per row
            mainAxisSize: MainAxisSize.min,
            children: [
              // The code field
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Code (e.g. CSCI 4311)'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }
                  return null;
                },
              ),
              
              // The name field
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) => (v?.trim().isEmpty ?? true) 
                    ? 'Name is required' 
                    : null,
              ),

              DropdownButtonFormField<String>(
                initialValue: _day,
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),

              // Spacing and the Slider row
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancle'),
        ),
        FilledButton(
          onPressed: _submit, // the check-and-add button
          child: const Text('Add'),
        ),
      ],
    );
  }
}