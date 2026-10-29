
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const Color _turquoise = Color(0xFF009FA3);
const Color _darkTurquoise = Color(0xFF007C80);
const Color _paleAqua = Color(0xFFEAF9F8);

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedDay = 'Monday';
  int _creditHours = 3;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newCourse = Course(
      _codeController.text.trim().toUpperCase(),
      _nameController.text.trim(),
      _creditHours,
      _selectedDay,
      Icons.book_outlined,
    );

    Navigator.pop(context, newCourse);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _paleAqua,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Text(
        'Add New Course',
        style: TextStyle(
          color: _darkTurquoise,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Course Code',
                  hintText: 'e.g. CSCI 4311',
                  prefixIcon: const Icon(
                    Icons.code,
                    color: _turquoise,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: _turquoise,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a course code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  hintText: 'e.g. Mobile Application Development',
                  prefixIcon: const Icon(
                    Icons.menu_book,
                    color: _turquoise,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: _turquoise,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Class Day',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
               initialValue: _selectedDay,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: _turquoise,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: _days.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDay = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Credit Hours: $_creditHours',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Slider(
                value: _creditHours.toDouble(),
                min: 1,
                max: 6,
                divisions: 5,
                activeColor: _turquoise,
                label: '$_creditHours CH',
                onChanged: (value) {
                  setState(() {
                    _creditHours = value.round();
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: _darkTurquoise),
          ),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: _turquoise,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Add Course'),
        ),
      ],
    );
  }
}
