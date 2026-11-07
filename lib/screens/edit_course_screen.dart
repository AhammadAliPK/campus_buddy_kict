import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Homework 2: a full screen with the form pre-filled from the course.
// Save pops the edited Course; system back pops null (= cancelled).
class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _codeCtrl = TextEditingController(text: widget.course.code);
  late final _nameCtrl = TextEditingController(text: widget.course.name);
  late final _timeCtrl = TextEditingController(text: widget.course.time);
  late final _venueCtrl = TextEditingController(text: widget.course.venue);
  late final _instructorCtrl =
      TextEditingController(text: widget.course.instructor ?? '');
  late String _day = widget.course.day;
  late int _creditHours = widget.course.creditHours;

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    _instructorCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final instructor = _instructorCtrl.text.trim();
    final c = widget.course;
    // Built directly (not copyWith) so an emptied instructor really becomes null
    final edited = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      _timeCtrl.text.trim().isEmpty ? 'TBA' : _timeCtrl.text.trim(),
      _venueCtrl.text.trim().isEmpty ? 'TBA' : _venueCtrl.text.trim(),
      c.icon,
      instructor: instructor.isEmpty ? null : instructor,
      isFavorite: c.isFavorite,
      enrolled: c.enrolled,
    );
    Navigator.pop(context, edited); // close AND answer
  }

  @override
  Widget build(BuildContext context) {
    // A day like 'Tuesday/Thursday' isn't in the list; keep it selectable.
    final days = _days.contains(_day) ? _days : [_day, ..._days];

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(labelText: 'Code'),
              validator: (v) {
                final t = v?.trim().toUpperCase() ?? '';
                if (t.isEmpty) return 'Code is required';
                if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                  return 'Format: 4 letters + 4 digits';
                }
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
              decoration: const InputDecoration(labelText: 'Day'),
              items: days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _day = v!),
            ),
            TextFormField(
              controller: _timeCtrl,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextFormField(
              controller: _venueCtrl,
              decoration: const InputDecoration(labelText: 'Venue'),
            ),
            TextFormField(
              controller: _instructorCtrl,
              decoration:
                  const InputDecoration(labelText: 'Instructor (optional)'),
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
                    onChanged: (v) => setState(() => _creditHours = v.round()),
                  ),
                ),
                Text('$_creditHours'),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
