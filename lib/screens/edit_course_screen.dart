
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<EditCourseScreen> createState() =>
      _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _timeController;
  late TextEditingController _venueController;

  late String _day;
  late int _creditHours;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController(
      text: widget.course.code,
    );

    _nameController = TextEditingController(
      text: widget.course.name,
    );

    _timeController = TextEditingController(
      text: widget.course.time,
    );

    _venueController = TextEditingController(
      text: widget.course.venue,
    );

    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedCourse = widget.course.copyWith(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      day: _day,
      creditHours: _creditHours,
      time: _timeController.text.trim(),
      venue: _venueController.text.trim(),
    );

    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Course Code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter course code';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter course name';
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
                return DropdownMenuItem(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _day = value;
                  });
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
                setState(() {
                  _creditHours = value.round();
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter time';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _venueController,
              decoration: const InputDecoration(
                labelText: 'Venue',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter venue';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _saveCourse,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),

            const SizedBox(height: 8),

            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
