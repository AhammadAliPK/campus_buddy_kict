import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/widgets/days_form_field.dart';

class AddCourseDialog extends StatefulWidget {
  // Exercise: the screen passes in the codes it already has
  const AddCourseDialog({super.key, required this.existingCodes});

  final List<String> existingCodes;

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>(); // the form's name tag
  final _codeCtrl = TextEditingController(); // remembers the typing
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(); // Week 4 homework
  final _venueCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController(); // may stay empty

  List<String> _days = ['Monday']; // the ticked day chips

  double _creditHours = 3; // the slider's current value (0.5 steps)

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    _instructorCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return; // run every check
    final instructor = _instructorCtrl.text.trim();
    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _days,
      Icons.auto_stories,
      time: _timeCtrl.text.trim(),
      venue: _venueCtrl.text.trim(),
      instructor: instructor.isEmpty ? null : instructor, // empty -> unknown
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
                  if (widget.existingCodes.contains(t)) {
                    return 'Already added';
                  }
                  return null; // returning null means "this input is fine"
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),
              DaysFormField(
                initialDays: _days,
                onChanged: (v) => _days = v,
              ),
              TextFormField(
                controller: _timeCtrl,
                decoration:
                    const InputDecoration(labelText: 'Time (e.g. 09:00–10:30)'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Time is required' : null,
              ),
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(labelText: 'Venue (e.g. LT A)'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Venue is required' : null,
              ),
              TextFormField(
                controller: _instructorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Instructor (leave empty if not known)',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Credit hours'),
                  Expanded(
                    child: Slider(
                      min: 0.5,
                      max: 4,
                      divisions: 7, // 0.5 steps: 0.5, 1, 1.5 ... 4
                      label: formatCh(_creditHours),
                      value: _creditHours,
                      onChanged: (v) => setState(() => _creditHours = v),
                    ),
                  ),
                  Text(formatCh(_creditHours)),
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
