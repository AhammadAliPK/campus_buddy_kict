import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _instructorCtrl = TextEditingController();

  // Custom state for the native clock UI
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _timeError = false; // Tracks manual validation for the time picker buttons

  String _day = 'Monday';
  int _creditHours = 3;
  IconData _selectedIcon = Icons.auto_stories; // Holds the chosen icon

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  // A list of relevant icons for the user to choose from
  static const _availableIcons = [
    Icons.auto_stories,
    Icons.computer,
    Icons.phone_iphone,
    Icons.language,
    Icons.data_exploration,
    Icons.code,
    Icons.science,
    Icons.calculate,
    Icons.psychology,
    Icons.terminal,
  ];

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks when the popup closes
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _instructorCtrl.dispose();
    super.dispose();
  }

  // Opens the native Flutter time picker and saves the result
  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        // Instantly clear the red error text once both times are selected
        if (_startTime != null && _endTime != null) {
          _timeError = false; 
        }
      });
    }
  }

  void _submit() {
    // 1. Manually check the time picker state
    setState(() {
      _timeError = _startTime == null || _endTime == null;
    });

    // 2. Trigger the built-in form validators for Code and Name
    final isFormValid = _formKey.currentState!.validate();

    // 3. Block submission if EITHER the time or the text fields fail
    if (_timeError || !isFormValid) return;

    // 4. Format the TimeOfDay objects into a standard "HH:mm-HH:mm" string
    final formattedTime = '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}-'
                          '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

    final venueText = _venueCtrl.text.trim();

    // 5. Package the data into the Course model and close the dialog
    final course = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      _selectedIcon, // Now uses the user's selected icon
      formattedTime,
      venueText.isEmpty ? 'TBA' : venueText, // Fallback for optional venue
      _instructorCtrl.text.trim().isEmpty ? null : _instructorCtrl.text.trim(), // Optional instructor handles nulls in the UI
    );
    Navigator.pop(context, course); // Pass the completed course back to the list
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
              // --- SECTION 1: COURSE IDENTITY ---
              // 1. Course Code
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Code (e.g. CSCI 4300)'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Code is required';
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(t)) return 'Format: 4 letters + 4 digits';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. Course Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),

              // 3. Icon Selection (Visual Grid)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose an Icon', style: TextStyle(fontSize: 12, color: Colors.black87)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: _availableIcons.map((icon) {
                  final isSelected = _selectedIcon == icon;
                  return IconButton(
                    icon: Icon(icon),
                    isSelected: isSelected,
                    style: IconButton.styleFrom(
                      backgroundColor: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                      foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.grey.shade600,
                    ),
                    onPressed: () => setState(() => _selectedIcon = icon),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // --- SECTION 2: LOGISTICS ---
              // 4. Day of the week
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(labelText: 'Day'),
                items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
              const SizedBox(height: 12),

              // 5. Time selection (Native Picker)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      icon: const Icon(Icons.access_time),
                      label: Text(_startTime == null 
                          ? 'Start Time' 
                          : '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'),
                      onPressed: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      icon: const Icon(Icons.access_time),
                      label: Text(_endTime == null 
                          ? 'End Time' 
                          : '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'),
                      onPressed: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              // Conditional red error text for manual time validation
              if (_timeError)
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Please select both start and end times',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // --- SECTION 3: ACADEMIC DETAILS ---
              // 6. Credit Hours
              Row(
                children: [
                  const Text('Credit hours'),
                  Expanded(
                    child: Slider(
                      min: 1, max: 4, divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (v) => setState(() => _creditHours = v.round()),
                    ),
                  ),
                  Text('$_creditHours'),
                ],
              ),
              const SizedBox(height: 12),

              // 7. Venue (Optional)
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(labelText: 'Venue (Optional)'),
              ),
              const SizedBox(height: 12),

              // 8. Instructor (Optional)
              TextFormField(
                controller: _instructorCtrl,
                decoration: const InputDecoration(labelText: 'Instructor (Optional)'),
              ),
              const SizedBox(height: 12),
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
          child: const Text('Add'),
        ),
      ],
    );
  }
}