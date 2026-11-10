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
  late final _nameCtrl = TextEditingController(text: widget.course.name);
  late final _timeCtrl = TextEditingController(text: widget.course.time);
  late final _venueCtrl = TextEditingController(text: widget.course.venue);
  late final _instructorCtrl = TextEditingController(
    text: widget.course.instructor ?? '',
  );
  late int _creditHours = widget.course.creditHours;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    _instructorCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final instructor = _instructorCtrl.text.trim();
    Navigator.pop(
      context,
      widget.course.copyWith(
        name: _nameCtrl.text.trim(),
        creditHours: _creditHours,
        time: _timeCtrl.text.trim(),
        venue: _venueCtrl.text.trim(),
        instructor: instructor,
        clearInstructor: instructor.isEmpty, // empty box = TBA
      ),
    );
  }

  String? _required(String? v) =>
      (v?.trim().isEmpty ?? true) ? 'Required' : null;

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
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Course name'),
              validator: _required,
            ),
            TextFormField(
              controller: _timeCtrl,
              decoration: const InputDecoration(labelText: 'Time'),
              validator: _required,
            ),
            TextFormField(
              controller: _venueCtrl,
              decoration: const InputDecoration(labelText: 'Venue'),
              validator: _required,
            ),
            TextFormField(
              controller: _instructorCtrl,
              decoration: const InputDecoration(
                labelText: 'Instructor (optional)',
              ),
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
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
