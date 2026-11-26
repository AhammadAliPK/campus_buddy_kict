import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Pre-filled form. Save pops the edited Course; system back pops null (cancelled).
class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({
    super.key,
    required this.course,
    this.existingCodes = const [],
  });

  final Course course;
  final List<String> existingCodes;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;
  late String _day;
  late int _creditHours;
  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController(text: widget.course.code);
    _nameCtrl = TextEditingController(text: widget.course.name);
    _day = widget.course.day;
    _creditHours = widget.course.creditHours.clamp(1, 4);
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // Keep a day like 'Tue, Thu' selectable even though it isn't a single weekday.
  List<String> get _days => _weekdays.contains(widget.course.day)
      ? _weekdays
      : [widget.course.day, ..._weekdays];

  String _normalise(String code) =>
      code.replaceAll(RegExp(r'\s'), '').toUpperCase();

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      widget.course.copyWith(
        code: _codeCtrl.text.trim().toUpperCase(),
        name: _nameCtrl.text.trim(),
        day: _day,
        creditHours: _creditHours,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Other courses' codes: the course may keep its own code.
    final others = widget.existingCodes
        .map(_normalise)
        .where((c) => c != _normalise(widget.course.code))
        .toSet();
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
                if (others.contains(_normalise(t))) return 'Already added';
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
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
