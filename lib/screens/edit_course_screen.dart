import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({
    super.key,
    required this.course,
    required this.existingCodes,
  });

  final Course course;
  final List<String> existingCodes;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _timeCtrl;
  late TextEditingController _venueCtrl;

  late String _day;
  static const _days = ['M-W', 'T-TH', 'MON', 'TUE', 'WED', 'THU', 'FRI'];
  late int _creditHours;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing course data
    _codeCtrl = TextEditingController(text: widget.course.code);
    _nameCtrl = TextEditingController(text: widget.course.name);
    _timeCtrl = TextEditingController(text: widget.course.time);
    _venueCtrl = TextEditingController(text: widget.course.venue);

    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Build the updated course instance
    final updatedCourse = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      _timeCtrl.text.trim(),
      _venueCtrl.text.trim(),
      widget.course.icon,
    );

    // Return the updated course back to the calling screen
    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Course Code Field
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4311)',
                ),
                validator: (v) {
                  final t = v?.trim().toUpperCase() ?? '';
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }
                  // Allow saving if code is unchanged, but prevent changing to another existing code
                  if (t != widget.course.code.toUpperCase() &&
                      widget.existingCodes.contains(t)) {
                    return 'Already added.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Course Name Field
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? 'Name is required.'
                    : null,
              ),
              const SizedBox(height: 12),

              // Day Dropdown
              DropdownButtonFormField<String>(
                value: _day,
                decoration: const InputDecoration(labelText: 'Days'),
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
              const SizedBox(height: 12),

              // Time Field (e.g. 08.30-10.00)
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 08.30-10.00)',
                  hintText: 'HH.MM-HH.MM',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Time is required';
                  if (!RegExp(r'^\d{2}\.\d{2}-\d{2}\.\d{2}$').hasMatch(t)) {
                    return 'Use format HH.MM-HH.MM (e.g. 08.30-10.00)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Venue Field
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (e.g. BK3 / Lab 2)',
                ),
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? 'Venue is required.'
                    : null,
              ),
              const SizedBox(height: 16),

              // Credit Hours Slider
              Row(
                children: [
                  const Text('Credit Hours'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (v) =>
                          setState(() => _creditHours = v.round()),
                    ),
                  ),
                  Text('$_creditHours'),
                ],
              ),
              const SizedBox(height: 24),

              // Save Button
              FilledButton(
                onPressed: _submit,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}