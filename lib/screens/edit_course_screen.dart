
import 'package:flutter/material.dart';
import '../models/course.dart';

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
  late final TextEditingController _creditController;
  late final TextEditingController _dayController;
  late final TextEditingController _timeController;
  late final TextEditingController _venueController;
  late final TextEditingController _instructorController;

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.name);
    _creditController = TextEditingController(
      text: widget.course.creditHours.toString(),
    );
    _dayController = TextEditingController(text: widget.course.day);
    _timeController = TextEditingController(text: widget.course.time);
    _venueController = TextEditingController(text: widget.course.venue);
    _instructorController = TextEditingController(
      text: widget.course.instructor ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _creditController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;

    final updatedCourse = widget.course.copyWith(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      creditHours: int.parse(_creditController.text.trim()),
      day: _dayController.text.trim(),
      time: _timeController.text.trim(),
      venue: _venueController.text.trim(),
      instructor: _instructorController.text.trim(),
    );

    Navigator.pop(context, updatedCourse);
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (requiredField && (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }

          if (label == 'Credit Hours') {
            final credits = int.tryParse(value?.trim() ?? '');
            if (credits == null || credits <= 0) {
              return 'Please enter valid credit hours';
            }
          }

          return null;
        },
      ),
    );
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
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Update Course Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildField(
              label: 'Course Code',
              controller: _codeController,
            ),
            _buildField(
              label: 'Course Name',
              controller: _nameController,
            ),
            _buildField(
              label: 'Credit Hours',
              controller: _creditController,
              keyboardType: TextInputType.number,
            ),
            _buildField(
              label: 'Day',
              controller: _dayController,
            ),
            _buildField(
              label: 'Time',
              controller: _timeController,
            ),
            _buildField(
              label: 'Venue',
              controller: _venueController,
            ),
            _buildField(
              label: 'Instructor',
              controller: _instructorController,
              requiredField: false,
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _saveCourse,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
