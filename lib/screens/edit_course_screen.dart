import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({
    super.key,
    required this.course,
  });

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  late final TextEditingController _instructorController;
  late final TextEditingController _venueController;
  late final TextEditingController _creditController;

  late String _day;

  @override
  void initState() {
    super.initState();

    // Pre-fill the form using the selected course.
    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.name);
    _timeController = TextEditingController(text: widget.course.time);
    _instructorController =
        TextEditingController(text: widget.course.instructor ?? '');
    _venueController = TextEditingController(text: widget.course.venue);
    _creditController = TextEditingController(
      text: widget.course.creditHours.toString(),
    );

    _day = widget.course.day;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _timeController.dispose();
    _instructorController.dispose();
    _venueController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;

    final editedCourse = Course(
      _codeController.text.trim().toUpperCase(),
      _nameController.text.trim(),
      int.parse(_creditController.text.trim()),
      _day,
      widget.course.icon,
      _timeController.text.trim(),
      _instructorController.text.trim().isEmpty
          ? null
          : _instructorController.text.trim(),
      _venueController.text.trim(),
      isFavorite: widget.course.isFavorite,
      enrolled: widget.course.enrolled,
    );

    // Return the edited Course to the previous screen.
    Navigator.pop(context, editedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveCourse,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Course code',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter course code'
                      : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Course name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter course name'
                      : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _creditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Credit hours',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final number = int.tryParse(value ?? '');
                if (number == null || number <= 0) {
                  return 'Enter a valid number of credit hours';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
              ),
              items: const [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
              ].map((day) {
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
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _instructorController,
              decoration: const InputDecoration(
                labelText: 'Instructor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _venueController,
              decoration: const InputDecoration(
                labelText: 'Venue',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

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