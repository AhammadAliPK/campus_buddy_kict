import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _venueCtrl;
  late String _day;
  late int _creditHours;

  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
  ];

  // Pre-fill every field from the course we were given
  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _codeCtrl = TextEditingController(text: c.code);
    _nameCtrl = TextEditingController(text: c.name);
    _timeCtrl = TextEditingController(text: c.time);
    _venueCtrl = TextEditingController(text: c.venue);
    _day = c.day;
    _creditHours = c.creditHours;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  // Check every field, then pop the edited copy as the answer
  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final edited = widget.course.copyWith(
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      day: _day,
      creditHours: _creditHours,
      time: _timeCtrl.text.trim(),
      venue: _venueCtrl.text.trim(),
    );
    Navigator.pop(context, edited);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(
                labelText: 'Code (e.g. CSCI 4311)',
              ),
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
            TextFormField(
              controller: _timeCtrl,
              decoration: const InputDecoration(labelText: 'Time'),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Time is required' : null,
            ),
            TextFormField(
              controller: _venueCtrl,
              decoration: const InputDecoration(labelText: 'Venue'),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Venue is required' : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _day,
              items: _days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _day = v!),
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
            FilledButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}