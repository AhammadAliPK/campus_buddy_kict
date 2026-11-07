import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

String _fmt(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({
    super.key,
    required this.course,
    required this.otherCodes,
  });

  final Course course;
  final List<String> otherCodes;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _venueCtrl;
  late final TextEditingController _instructorCtrl;
  late String _day;
  late double _creditHours;

  static const _baseDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Mon, Wed', 'Tue, Thu'
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.course; // form starts pre-filled with the course
    _codeCtrl = TextEditingController(text: c.code);
    _nameCtrl = TextEditingController(text: c.name);
    _timeCtrl = TextEditingController(text: c.time);
    _venueCtrl = TextEditingController(text: c.venue);
    _instructorCtrl = TextEditingController(text: c.instructor ?? '');
    _day = c.day;
    _creditHours = c.creditHours;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    _instructorCtrl.dispose();
    super.dispose();
  }

  String _norm(String s) => s.replaceAll(' ', '').toUpperCase();

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final raw = _norm(_codeCtrl.text.trim());
    final code = '${raw.substring(0, 4)} ${raw.substring(4)}';
    final time = _timeCtrl.text.trim();
    final venue = _venueCtrl.text.trim();
    final instructor = _instructorCtrl.text.trim();
    final c = widget.course;
    Navigator.pop(
      context,
      Course(
        code,
        _nameCtrl.text.trim(),
        _creditHours,
        _day,
        time.isEmpty ? 'TBA' : time,
        venue.isEmpty ? 'TBA' : venue,
        c.icon,
        instructor: instructor.isEmpty ? null : instructor,
        isFavorite: c.isFavorite,
        enrolled: c.enrolled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _baseDays.contains(_day) ? _baseDays : [..._baseDays, _day];
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
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Code is required';
                if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                  return 'Format: 4 letters + 4 digits';
                }
                if (widget.otherCodes.any((c) => _norm(c) == _norm(t))) {
                  return 'Already added';
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
              decoration: const InputDecoration(labelText: 'Days'),
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
              decoration: const InputDecoration(
                labelText: 'Lecturer (leave empty if unknown)',
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
                    divisions: 7,
                    label: _fmt(_creditHours),
                    value: _creditHours.clamp(0.5, 4.0).toDouble(),
                    onChanged: (v) =>
                        setState(() => _creditHours = (v * 2).round() / 2),
                  ),
                ),
                Text(_fmt(_creditHours)),
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
