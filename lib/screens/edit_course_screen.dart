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

    final updatedCourse = widget.course.copyWith(
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      day: _day,
      creditHours: _creditHours,
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
                labelText: 'Course code',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final code = v?.trim().toUpperCase() ?? '';

                if (code.isEmpty) {
                  return 'Code is required';
                }

                if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(code)) {
                  return 'Format: 4 letters + 4 digits';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Course name',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
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
                  setState(() {
                    _day = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            Text('Credit hours: $_creditHours'),

            Slider(
              min: 1,
              max: 4,
              divisions: 3,
              label: '$_creditHours',
              value: _creditHours.toDouble(),
              onChanged: (value) {
                setState(() {
                  _creditHours = value.round();
                });
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
