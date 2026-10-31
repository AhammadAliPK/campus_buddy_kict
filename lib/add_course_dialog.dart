import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  final List<String> existingCodes;

  const AddCourseDialog({
    super.key,
    required this.existingCodes
  });

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  
  // Controllers for Time and Venue
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  String _day = 'M-W';
  static const _days = [
    'M-W', 'T-TH', 'MON', 'TUE', 'WED', 'THU', 'FRI'
  ];
  int _creditHours = 3;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    final course = Course(
      _codeCtrl.text.trim().toUpperCase(), 
      _nameCtrl.text.trim(), 
      _creditHours, 
      _day, 
      _timeCtrl.text.trim(),
      _venueCtrl.text.trim(),
      Icons.auto_stories,
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
              // Course Code Field
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
                  if (widget.existingCodes.contains(t)){
                    return 'Already added.';
                  }
                  return null;
                },
              ),
              
              // Course Name Field
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (v) => (v?.trim().isEmpty ?? true)
                  ? 'Name is required.'
                  : null,
              ),

              // Day Dropdown
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(labelText: 'Days'),
                items: _days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),

              // Time Field (e.g. 08.30-10.00)
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 08.30-10.00)',
                  hintText: 'HH.MM-HH.MM',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Time is required';
                  // Optional regex to ensure format like "08.30-10.00" or "8.30-10.30"
                  if (!RegExp(r'^\d{2}\.\d{2}-\d{2}\.\d{2}$').hasMatch(t)) {
                    return 'Use format HH.MM-HH.MM (e.g. 08.30-10.00)';
                  }
                  return null;
                },
              ),

              // Venue Field
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (e.g. BK3 / Lab 2)',
                ),
                validator: (v) => (v?.trim().isEmpty ?? true)
                  ? 'Venue is required.'
                  : null,
              ),
              const SizedBox(height: 12),

              // Credit Hours Slider
              Row(
                children: [
                  const Text('Credit Hours'),
                  Expanded(
                    child: Slider(
                      min: 1, max: 4, divisions: 3,
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
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}