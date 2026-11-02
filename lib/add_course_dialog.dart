import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key, required this.existingCodes});

  // Exercise: codes already in the list, used by the duplicate guard
  final List<String> existingCodes;

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  String _day = 'Monday';
  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
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
    final time = _timeCtrl.text.trim();
    final venue = _venueCtrl.text.trim();
    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      Icons.auto_stories,
      time.isEmpty ? 'TBA' : time,
      venue.isEmpty ? 'TBA' : venue,
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
                  // Exercise: duplicate guard (ignores case and the space)
                  final key = t.toUpperCase().replaceAll(' ', '');
                  final taken = widget.existingCodes.any(
                      (c) => c.toUpperCase().replaceAll(' ', '') == key);
                  if (taken) return 'Already added';
                  return null;
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
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (optional, e.g. 09:00–10:30)',
                ),
              ),
              TextFormField(
                controller: _venueCtrl,
                decoration:
                    const InputDecoration(labelText: 'Venue (optional)'),
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
