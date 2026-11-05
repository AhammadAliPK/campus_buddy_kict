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
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  late final TextEditingController _venueController;
  late final TextEditingController _instructorController;
  late String _selectedDay;
  late double _creditHours;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.name);
    _timeController = TextEditingController(text: widget.course.time);
    _venueController = TextEditingController(text: widget.course.venue);
    _instructorController = TextEditingController(
      text: widget.course.instructor ?? '',
    );
    _selectedDay = widget.course.day;
    _creditHours = widget.course.creditHours.toDouble();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final instructorText = _instructorController.text.trim();
      final editedCourse = widget.course.copyWith(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        creditHours: _creditHours.round(),
        day: _selectedDay,
        time: _timeController.text.trim().isEmpty
            ? 'TBA'
            : _timeController.text.trim(),
        venue: _venueController.text.trim().isEmpty
            ? 'TBA'
            : _venueController.text.trim(),
        instructor: instructorText.isEmpty ? null : instructorText,
      );
      Navigator.pop(context, editedCourse);
    }
  }

  @override
  Widget build(BuildContext context) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Course code'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Code is required';
                  }
                  if (!value.trim().startsWith(RegExp(r'^[A-Z]{4}'))) {
                    return 'Start with 4 letters, e.g. CSCI 4311';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Course name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: 'Venue'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(
                  labelText: 'Instructor (leave blank for TBA)',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Day', style: TextStyle(fontWeight: FontWeight.bold)),
              for (final day in days)
                RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(day),
                  value: day,
                  groupValue: _selectedDay,
                  onChanged: (v) => setState(() => _selectedDay = v!),
                ),
              const SizedBox(height: 8),
              Text(
                'Credit hours: ${_creditHours.round()} CH',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                min: 1,
                max: 4,
                divisions: 3,
                value: _creditHours,
                label: '${_creditHours.round()}',
                onChanged: (v) => setState(() => _creditHours = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveChanges,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}