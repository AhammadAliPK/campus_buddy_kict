import 'package:flutter/material.dart';

import '../models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({required this.course, super.key});

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  late final TextEditingController _roomController;
  late final TextEditingController _lecturerController;
  late final TextEditingController _descriptionController;
  late String _day;
  late double _credits;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.title);
    _timeController = TextEditingController(text: widget.course.time);
    _roomController = TextEditingController(text: widget.course.room);
    _lecturerController = TextEditingController(text: widget.course.lecturer);
    _descriptionController = TextEditingController(
      text: widget.course.description,
    );
    _day = widget.course.day;
    _credits = widget.course.credits.toDouble();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _timeController.dispose();
    _roomController.dispose();
    _lecturerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      widget.course.copyWith(
        code: _codeController.text.trim().toUpperCase(),
        title: _nameController.text.trim(),
        day: _day,
        time: _timeController.text.trim(),
        room: _roomController.text.trim(),
        lecturer: _lecturerController.text.trim(),
        credits: _credits.round(),
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = <String>{
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Monday - Wednesday',
      'Tuesday - Thursday',
      _day,
    }.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit course'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Course code'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Course code is required'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course name'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Course name is required'
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Day'),
              items: days
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
              onChanged: (value) => setState(() => _day = value ?? _day),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _roomController,
              decoration: const InputDecoration(labelText: 'Venue'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lecturerController,
              decoration: const InputDecoration(labelText: 'Lecturer'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Credit hours'),
                Expanded(
                  child: Slider(
                    value: _credits,
                    min: 1,
                    max: 6,
                    divisions: 5,
                    label: '${_credits.round()}',
                    onChanged: (value) => setState(() => _credits = value),
                  ),
                ),
                Text('${_credits.round()}'),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
