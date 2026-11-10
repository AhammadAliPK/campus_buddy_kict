import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key, required this.existingCodes});

  final List<String> existingCodes;

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();
  final Set<String> _selectedDays = {};
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  int _creditHours = 3;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    _instructorCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _days.where(_selectedDays.contains).toList(),
      _timeCtrl.text.trim().toLowerCase().replaceAll(
        RegExp(r'\s*[-–]\s*'),
        '–',
      ),
      _venueCtrl.text.trim(),
      Icons.auto_stories,
      instructor: _instructorCtrl.text.trim().isEmpty
          ? null
          : _instructorCtrl.text.trim(),
    );
    Navigator.pop(context, course);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First child: Course code
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code (e.g. CSCI 4311)',
                ),
                validator: (v) {
                  final t = (v?.trim() ?? '').toUpperCase();
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }
                  final key = t.replaceAll(' ', '');
                  if (widget.existingCodes.any(
                    (c) => c.toUpperCase().replaceAll(' ', '') == key,
                  )) {
                    return 'Already added';
                  }
                  return null;
                },
              ),

              // Second child: Course name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),

              const SizedBox(height: 12),
              FormField<Set<String>>(
                validator: (_) =>
                    _selectedDays.isEmpty ? 'Pick at least 1 day' : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Class days'),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (final d in _days)
                          FilterChip(
                            label: Text(d.substring(0, 3)),
                            selected: _selectedDays.contains(d),
                            onSelected: (on) {
                              setState(
                                () => on
                                    ? _selectedDays.add(d)
                                    : _selectedDays.remove(d),
                              );
                              if (field.hasError) field.validate();
                            },
                          ),
                      ],
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 3:30pm–4:50pm)',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Time is required';
                  if (!RegExp(
                    r'^\d{1,2}:\d{2}(am|pm)\s*[-–]\s*\d{1,2}:\d{2}(am|pm)$',
                    caseSensitive: false,
                  ).hasMatch(t)) {
                    return 'Format: 3:30pm–4:50pm';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (e.g. LR13 Level 2D)',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Venue is required' : null,
              ),

              TextFormField(
                controller: _instructorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Instructor (optional)',
                  hintText: 'e.g. Dr. Ahmad Anwar Bin Zainuddin',
                ),
              ),

              // Fourth child: Credit hours slider
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
                      onChanged: (v) =>
                          setState(() => _creditHours = v.round()),
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
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
