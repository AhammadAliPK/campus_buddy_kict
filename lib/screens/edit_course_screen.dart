import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _creditHoursController;
  late final TextEditingController _timeController;
  late final TextEditingController _venueController;
  late final TextEditingController _instructorController;

  late String _selectedDay;

  @override
  void initState() {
    super.initState();

    // Prefill the form using existing course details
    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.name);
    _creditHoursController = TextEditingController(
      text: widget.course.creditHours.toString(),
    );
    _timeController = TextEditingController(text: widget.course.time);
    _venueController = TextEditingController(text: widget.course.venue);
    _instructorController = TextEditingController(
      text: widget.course.instructor ?? '',
    );

    _selectedDay = widget.course.day;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _creditHoursController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;

    final editedCourse = widget.course.copyWith(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      creditHours: int.parse(_creditHoursController.text.trim()),
      day: _selectedDay,
      time: _timeController.text.trim(),
      venue: _venueController.text.trim(),
      instructor: _instructorController.text.trim().isEmpty
          ? null
          : _instructorController.text.trim(),
    );

    Navigator.pop(context, editedCourse);
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
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter course code'
                  : null,
            ),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter course name'
                  : null,
            ),

            TextFormField(
              controller: _creditHoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Credit Hours'),
              validator: (value) {
                final hours = int.tryParse(value?.trim() ?? '');
                if (hours == null || hours <= 0) {
                  return 'Enter valid credit hours';
                }
                return null;
              },
            ),

            DropdownButtonFormField<String>(
              initialValue: _selectedDay,
              decoration: const InputDecoration(labelText: 'Day'),
              items:
                  [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday',
                  ].map((day) {
                    return DropdownMenuItem(value: day, child: Text(day));
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDay = value;
                  });
                }
              },
            ),

            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter time' : null,
            ),

            TextFormField(
              controller: _venueController,
              decoration: const InputDecoration(labelText: 'Venue'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter venue' : null,
            ),

            TextFormField(
              controller: _instructorController,
              decoration: const InputDecoration(
                labelText: 'Instructor (Optional)',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveCourse,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
