import 'package:flutter/material.dart';

import 'models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _timeController = TextEditingController(text: '8:30 AM - 10:00 AM');
  final _roomController = TextEditingController();
  final _lecturerController = TextEditingController();
  String _day = 'Monday';
  double _credits = 3;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _timeController.dispose();
    _roomController.dispose();
    _lecturerController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      Course(
        code: _codeController.text.trim().toUpperCase(),
        title: _nameController.text.trim(),
        day: _day,
        time: _timeController.text.trim(),
        room: _roomController.text.trim().isEmpty
            ? 'To be confirmed'
            : _roomController.text.trim(),
        lecturer: _lecturerController.text.trim().isEmpty
            ? 'To be confirmed'
            : _lecturerController.text.trim(),
        credits: _credits.round(),
        color: Colors
            .primaries[DateTime.now().millisecond % Colors.primaries.length],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Course code',
                    hintText: 'CSCI 4311',
                  ),
                  validator: (value) {
                    final code = value?.trim().toUpperCase() ?? '';
                    if (!RegExp(r'^[A-Z]{4} \d{4}$').hasMatch(code)) {
                      return 'Use four letters, a space and four digits';
                    }
                    return null;
                  },
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
                  items:
                      const [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                          ]
                          .map(
                            (day) =>
                                DropdownMenuItem(value: day, child: Text(day)),
                          )
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
                const SizedBox(height: 8),
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
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
