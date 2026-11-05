import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Homework 2: a form pre-filled with one course. Save pops the edited
// Course back; the back button pops null (= cancelled).
class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();
  late String _day;
  late int _creditHours;
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    // pre-fill the form from the course we were given
    final c = widget.course;
    _nameCtrl.text = c.name;
    _timeCtrl.text = c.time;
    _venueCtrl.text = c.venue;
    _instructorCtrl.text = c.instructor ?? '';
    _day = c.day;
    _creditHours = c.creditHours;
  }

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
    final c = widget.course;
    final instructor = _instructorCtrl.text.trim();
    // Built with the constructor (not copyWith) so an emptied instructor
    // field really becomes null → shows 'TBA'. Star + enrolled are kept.
    final edited = Course(
      c.code,
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      _timeCtrl.text.trim(),
      _venueCtrl.text.trim(),
      c.icon,
      instructor: instructor.isEmpty ? null : instructor,
      isFavorite: c.isFavorite,
      enrolled: c.enrolled,
    );
    Navigator.pop(context, edited); // close AND answer
  }

  String? _required(String? v, String what) =>
      (v?.trim().isEmpty ?? true) ? '$what is required' : null;

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
              validator: (v) => _required(v, 'Name'),
            ),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Day'),
              items: [
                // keep the course's own day even if it is not Mon–Fri
                for (final d in {..._days, _day})
                  DropdownMenuItem(value: d, child: Text(d)),
              ],
              onChanged: (v) => setState(() => _day = v!),
            ),
            TextFormField(
              controller: _timeCtrl,
              decoration: const InputDecoration(
                labelText: 'Time (e.g. 09:00–10:30)',
              ),
              validator: (v) => _required(v, 'Time'),
            ),
            TextFormField(
              controller: _venueCtrl,
              decoration: const InputDecoration(labelText: 'Venue'),
              validator: (v) => _required(v, 'Venue'),
            ),
            TextFormField(
              controller: _instructorCtrl,
              decoration: const InputDecoration(
                labelText: 'Instructor (leave empty for TBA)',
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
