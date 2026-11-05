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
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late int _creditHours;
  late String _day;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course.code);
    _nameController = TextEditingController(text: widget.course.name);
    _creditHours = widget.course.creditHours;
    _day = _days.contains(widget.course.day) ? widget.course.day : 'Monday';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      
      final updatedCourse = widget.course.copyWith(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        creditHours: _creditHours,
        day: _day,
      );
      Navigator.pop(context, updatedCourse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Enter code' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _creditHours,
                decoration: const InputDecoration(labelText: 'Credit Hours'),
                items: [1, 2, 3, 4]
                    .map((ch) => DropdownMenuItem(
                          value: ch,
                          child: Text('$ch Credit Hours'),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _creditHours = val);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _day,
                decoration: const InputDecoration(labelText: 'Day'),
                items: _days
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _day = val);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}