import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key, required this.existingCodes, this.course});

  final List<String> existingCodes;
  final Course? course;

  bool get isEditing => course != null;

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeCtrl;
  late final TextEditingController _nameCtrl;

  late String _day;
  late int _creditHours;

  static const _days = ['M-W', 'T-TH', 'FRI'];

  @override
  void initState() {
    super.initState();

    // If editing, fill in the existing course details.
    // If adding, use the default values.
    _codeCtrl = TextEditingController(text: widget.course?.code ?? '');

    _nameCtrl = TextEditingController(text: widget.course?.name ?? '');

    _day = widget.course?.day ?? 'M-W';
    _creditHours = widget.course?.creditHours ?? 3;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final Course course;

    if (widget.course == null) {
      // Add a new course.
      course = Course(
        _codeCtrl.text.trim().toUpperCase(),
        _nameCtrl.text.trim(),
        _creditHours,
        _day,
        Icons.auto_stories,
      );
    } else {
      // Update the existing course.
      course = widget.course!.copyWith(
        code: _codeCtrl.text.trim().toUpperCase(),
        name: _nameCtrl.text.trim(),
        creditHours: _creditHours,
        day: _day,
      );
    }

    // Return the course to the previous screen.
    Navigator.pop(context, course);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Course' : 'Add a course'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4330)',
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) {
                  final t = v?.trim() ?? '';

                  if (t.isEmpty) {
                    return 'Code is required';
                  }

                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$')
                      .hasMatch(t.toUpperCase())) {
                    return 'Format: 4 letters + 4 digits';
                  }

                  final code = t.toUpperCase();

                  // Allow the current course to keep its own code.
                  if (widget.existingCodes.any(
                    (existingCode) =>
                        existingCode.toUpperCase() == code &&
                        existingCode.toUpperCase() !=
                            widget.course?.code.toUpperCase(),
                  )) {
                    return 'Already added';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),

              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(labelText: 'Day'),
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _day = v);
                  }
                },
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Text('Credit hours'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (v) {
                        setState(() {
                          _creditHours = v.round();
                        });
                      },
                    ),
                  ),
                  Text('$_creditHours'),
                ],
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),

        FilledButton(
          onPressed: _submit,
          child: Text(widget.isEditing ? 'Save Changes' : 'Add'),
        ),
      ],
    );
  }
}
