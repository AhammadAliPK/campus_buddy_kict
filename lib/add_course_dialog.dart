import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key, required this.existingCodes}); // NEW: screen passes codes already in list

  final List<String> existingCodes; // NEW: used by code validator to block duplicates

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _timeCtrl = TextEditingController(); // NEW: time field
  final _venueCtrl = TextEditingController(); // NEW: venue field
  final _instructorCtrl = TextEditingController(); // NEW: instructor field
  final Set<String> _selectedDays = {}; // CHANGED: start empty, no forced Monday; user picks 1+ days (e.g. Tue + Thu)
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  int _creditHours = 3;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose(); // ← NEW
    _timeCtrl.dispose(); // NEW: free controllers to avoid memory leak
    _venueCtrl.dispose(); // NEW
    _instructorCtrl.dispose(); // NEW
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final course = Course(
      // ← NEW: pack the answers
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      // CHANGED: keep Mon→Fri order, not tap order (list sort in screen uses days.first)
      _days.where(_selectedDays.contains).toList(),
      // NEW: normalise "-" to "–" so it matches courses.dart (e.g. 3:30pm–4:50pm)
      _timeCtrl.text.trim().toLowerCase().replaceAll(RegExp(r'\s*[-–]\s*'), '–'),
      _venueCtrl.text.trim(), // NEW: venue from field
      Icons.auto_stories,
      // NEW: empty instructor -> null, screen shows 'TBA'
      instructor: _instructorCtrl.text.trim().isEmpty
          ? null
          : _instructorCtrl.text.trim(),
    );
    Navigator.pop(context, course); // ← CHANGED: close AND answer
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
                  final t = (v?.trim() ?? '').toUpperCase(); // FIX: uppercase before check so "csci 4311" passes
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) {
                    return 'Format: 4 letters + 4 digits';
                  }
                  // NEW: duplicate guard; ignore spaces so "CSCI4311" also matches "CSCI 4311"
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

              // CHANGED: Third child: Day chips (pick 1 or more), was single dropdown
              const SizedBox(height: 12),
              // CHANGED: FormField so validate() on Add also checks days, like other fields
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
                            label: Text(d.substring(0, 3)), // Mon, Tue... same as screen chips
                            selected: _selectedDays.contains(d),
                            onSelected: (on) {
                              setState(() => on
                                  ? _selectedDays.add(d)
                                  : _selectedDays.remove(d)); // CHANGED: free toggle, any day can be removed
                              if (field.hasError) field.validate(); // CHANGED: re-check so red error clears once a day picked
                            },
                          ),
                      ],
                    ),
                    if (field.hasError) // CHANGED: show error under chips when none picked
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

              // NEW: Time, same format as courses.dart
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 3:30pm–4:50pm)',
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Time is required';
                  // NEW: start-end, each like 3:30pm; accepts "-" or "–", any case
                  if (!RegExp(
                    r'^\d{1,2}:\d{2}(am|pm)\s*[-–]\s*\d{1,2}:\d{2}(am|pm)$',
                    caseSensitive: false,
                  ).hasMatch(t)) {
                    return 'Format: 3:30pm–4:50pm';
                  }
                  return null;
                },
              ),

              // NEW: Venue
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (e.g. LR13 Level 2D)',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Venue is required' : null,
              ),

              // NEW: Instructor (optional, like nullable instructor in Course)
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
