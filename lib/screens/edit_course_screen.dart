import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

/// Pops the edited [Course] on Save. Back button pops `null` = cancelled.
class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _codeController = TextEditingController(text: widget.course.code);
  late final _nameController = TextEditingController(text: widget.course.name);
  late final _creditController =
      TextEditingController(text: '${widget.course.creditHours}');
  late final _timeController = TextEditingController(text: widget.course.time);
  late final _venueController =
      TextEditingController(text: widget.course.venue);
  late final _instructorController =
      TextEditingController(text: widget.course.instructor ?? '');
  late String _day = widget.course.day;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _creditController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final instructor = _instructorController.text.trim();
      final edited = widget.course.copyWith(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        creditHours: num.parse(_creditController.text.trim()),
        day: _day,
        time: _timeController.text.trim(),
        venue: _venueController.text.trim(),
        // copyWith treats null as "keep the old one", so empty becomes TBA
        instructor: instructor.isEmpty ? 'TBA' : instructor,
      );
      Navigator.pop(context, edited);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Two-day courses ("Tuesday & Thursday") aren't in weekDays, so keep the
    // current value as an option or the dropdown has nothing to show.
    final days = [if (!weekDays.contains(_day)) _day, ...weekDays];

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Course code'),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Code is required';
                }
                if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(value.trim())) {
                  return '4 letters and 4 digits, e.g. CSCI 4311';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Day'),
              items: [
                for (final d in days) DropdownMenuItem(value: d, child: Text(d)),
              ],
              onChanged: (v) => setState(() => _day = v ?? _day),
            ),
            TextFormField(
              controller: _creditController,
              decoration: const InputDecoration(labelText: 'Credit hours'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                final ch = num.tryParse(value?.trim() ?? '');
                if (ch == null || ch <= 0) {
                  return 'Enter a number, e.g. 3';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextFormField(
              controller: _venueController,
              decoration: const InputDecoration(labelText: 'Venue'),
            ),
            TextFormField(
              controller: _instructorController,
              decoration: const InputDecoration(labelText: 'Instructor'),
            ),
            const SizedBox(height: 24),
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
