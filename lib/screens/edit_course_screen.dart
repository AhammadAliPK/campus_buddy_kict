import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/widgets/days_form_field.dart';

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
  late final TextEditingController _instructorCtrl;
  late List<String> _days;
  late double _creditHours;

  @override
  void initState() {
    super.initState();
    // pre-fill every field from the course we were handed
    _codeCtrl = TextEditingController(text: widget.course.code);
    _nameCtrl = TextEditingController(text: widget.course.name);
    _timeCtrl = TextEditingController(text: widget.course.time);
    _venueCtrl = TextEditingController(text: widget.course.venue);
    _instructorCtrl =
        TextEditingController(text: widget.course.instructor ?? '');
    _days = List.of(widget.course.days);
    _creditHours = widget.course.creditHours;
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final instructor = _instructorCtrl.text.trim();
    final old = widget.course;
    // Built with Course(...) rather than copyWith, because copyWith cannot
    // set instructor back to null when the user clears the box.
    final edited = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _days,
      old.icon,
      time: _timeCtrl.text.trim(),
      venue: _venueCtrl.text.trim(),
      instructor: instructor.isEmpty ? null : instructor,
      isFavorite: old.isFavorite, // keep the star
      enrolled: old.enrolled, // keep the tick
    );
    Navigator.pop(context, edited); // hand the edited course back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _codeCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Code (e.g. CSCI 4311)'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
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
                        min: 0.5, max: 4, divisions: 7, // 0.5 steps
                        label: formatCh(_creditHours),
                        value: _creditHours,
                        onChanged: (v) => setState(() => _creditHours = v),
                      ),
                    ),
                    Text(formatCh(_creditHours)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Save changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}