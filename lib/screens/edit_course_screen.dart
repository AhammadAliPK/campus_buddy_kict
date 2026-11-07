
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _timeCtrl;
  late TextEditingController _venueCtrl;
  late TextEditingController _instructorCtrl;

  late String _day;
  late int _creditHours;

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void initState() {
    super.initState();

    final course = widget.course;

    _codeCtrl = TextEditingController(text: course.code);
    _nameCtrl = TextEditingController(text: course.name);
    _timeCtrl = TextEditingController(text: course.time);
    _venueCtrl = TextEditingController(text: course.venue);
    _instructorCtrl = TextEditingController(
      text: course.instructor ?? '',
    );

    _day = course.day;
    _creditHours = course.creditHours;
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

    final updatedCourse = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      widget.course.icon,
      _timeCtrl.text.trim().isEmpty ? 'TBA' : _timeCtrl.text.trim(),
      _venueCtrl.text.trim().isEmpty ? 'TBA' : _venueCtrl.text.trim(),
      _instructorCtrl.text.trim().isEmpty
          ? null
          : _instructorCtrl.text.trim(),
      isFavorite: widget.course.isFavorite,
      enrolled: widget.course.enrolled,
    );

    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = v?.trim() ?? '';

                  if (value.isEmpty) {
                    return 'Course code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$')
                      .hasMatch(value.toUpperCase())) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true)
                        ? 'Course name is required'
                        : null,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _day = value);
                  }
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _instructorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Instructor',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Text('Credit hours'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      value: _creditHours.toDouble(),
                      label: '$_creditHours',
                      onChanged: (value) {
                        setState(() {
                          _creditHours = value.round();
                        });
                      },
                    ),
                  ),
                  Text('$_creditHours'),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
