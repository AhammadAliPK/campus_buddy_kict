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

  late String _day;
  late int _creditHours;

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();

    _codeCtrl = TextEditingController(text: widget.course.code);
    _nameCtrl = TextEditingController(text: widget.course.name);
    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;

    final updatedCourse = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      widget.course.icon,
      isFavorite: widget.course.isFavorite,
      enrolled: widget.course.enrolled,
    );

    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(
                labelText: 'Course Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';

                if (text.isEmpty) {
                  return 'Code is required';
                }

                if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(text)) {
                  return 'Format: 4 letters + 4 digits';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
              ),
              items: _days.map((day) {
                return DropdownMenuItem(value: day, child: Text(day));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _day = value);
                }
              },
            ),
            const SizedBox(height: 16),

            Text('Credit Hours: $_creditHours'),
            Slider(
              min: 1,
              max: 4,
              divisions: 3,
              label: '$_creditHours',
              value: _creditHours.toDouble(),
              onChanged: (value) {
                setState(() => _creditHours = value.round());
              },
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _saveCourse,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
