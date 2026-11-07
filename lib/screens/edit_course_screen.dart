
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
  late TextEditingController _creditController;
  late TextEditingController _dayController;
  late TextEditingController _timeController;
  late TextEditingController _venueController;
  late TextEditingController _instructorController;

  @override
  void initState() {
    super.initState();

    _codeController =
        TextEditingController(text: widget.course.code);

    _nameController =
        TextEditingController(text: widget.course.name);

    _creditController =
        TextEditingController(
          text: widget.course.creditHours.toString(),
        );

    _dayController =
        TextEditingController(text: widget.course.day);

    _timeController =
        TextEditingController(text: widget.course.time);

    _venueController =
        TextEditingController(text: widget.course.venue);

    _instructorController =
        TextEditingController(
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedCourse = widget.course.copyWith(
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      creditHours: int.parse(_creditController.text),
      day: _dayController.text.trim(),
      time: _timeController.text.trim(),
      venue: _venueController.text.trim(),
      instructor: _instructorController.text.trim(),
    );

    Navigator.pop(context, updatedCourse);
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
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
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
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

        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveCourse,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              _buildField(
                'Course Code',
                _codeController,
              ),

              _buildField(
                'Course Name',
                _nameController,
              ),

              _buildField(
                'Credit Hours',
                _creditController,
                keyboardType: TextInputType.number,
              ),

              _buildField(
                'Day',
                _dayController,
              ),

              _buildField(
                'Time',
                _timeController,
              ),

              _buildField(
                'Venue',
                _venueController,
              ),

              _buildField(
                'Instructor',
                _instructorController,
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,

                child: FilledButton.icon(
                  onPressed: _saveCourse,
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
