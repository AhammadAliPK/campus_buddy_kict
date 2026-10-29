import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';         // Step 13: popup builds a Course

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();       // Step 8: name tag so Add can check the form
  final _codeCtrl = TextEditingController();     // Step 8: holds what's typed in Code
  final _nameCtrl = TextEditingController();     // Step 10: holds what's typed in Name
  String _day = 'Monday';                        // Step 11: dropdown's current choice
  static const _days = [                         // Step 11: dropdown options
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
  ];
  int _creditHours = 3;                          // Step 12: slider's current value

  @override
  void dispose() {                               // Step 8: clean up when the popup closes
    _codeCtrl.dispose();
    _nameCtrl.dispose();                         // Step 10
    super.dispose();
  }

  void _submit() {                               // Step 9 (grows in Step 13)
    if (!_formKey.currentState!.validate()) return;
    // run every validator. Any error → red text shows, and STOP here (return)
    final course = Course(                       // Step 13: pack the answers into a Course
      _codeCtrl.text.trim().toUpperCase(),       // code, tidied: 'csci 4311' → 'CSCI 4311'
      _nameCtrl.text.trim(),                     // name
      _creditHours,                              // from the slider
      _day,                                      // from the dropdown
      'TBA',                                     // time (not asked in popup)
      'TBA',                                     // venue
      Icons.auto_stories,                        // a default book icon
    );
    Navigator.pop(context, course);              // close the popup AND send the course back
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: Form(                             // Step 8: groups the fields
        key: _formKey,                           // attach the name tag
        child: SingleChildScrollView(            // Step 10: keyboard can't squash the fields
          child: Column(                         // Step 10: fields stacked top to bottom
            mainAxisSize: MainAxisSize.min,      // only as tall as needed
            children: [
              TextFormField(                     // Step 8: Code field
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4311)',
                ),
                validator: (v) {                 // Step 9: checking rule
                  final t = v?.trim() ?? '';     // the typed text, trimmed ('' if null)
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    // 4 capital letters, optional space, 4 digits
                    return 'Format: 4 letters + 4 digits';
                  }
                  return null;                   // null = OK
                },
              ),
              TextFormField(                     // Step 10: Name field
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? 'Name is required'         // empty (or null) → error
                    : null,                      // otherwise OK
              ),
              DropdownButtonFormField<String>(   // Step 11: day picker
                initialValue: _day,              // starts on Monday
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),                   // turn each day name into a menu item
                onChanged: (v) => setState(() => _day = v!), // remember the pick
              ),
              const SizedBox(height: 8),         // Step 12: small gap
              Row(                               // Step 12: label + slider + number
                children: [
                  const Text('Credit hours'),
                  Expanded(                      // slider takes the leftover width
                    child: Slider(
                      min: 1, max: 4, divisions: 3, // stops at 1, 2, 3, 4
                      label: '$_creditHours',       // bubble while dragging
                      value: _creditHours.toDouble(), // slider needs a double
                      onChanged: (v) =>
                          setState(() => _creditHours = v.round()), // back to whole number
                    ),
                  ),
                  Text('$_creditHours'),         // live number beside the slider
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // close with NO answer (null)
          child: const Text('Cancel'),             // Step 9: renamed from Close
        ),
        FilledButton(                              // Step 9: the Add button
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}