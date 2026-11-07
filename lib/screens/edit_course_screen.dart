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
  late TextEditingController _codeCtrl;
  late TextEditingController _nameCtrl;
  late String _day;
  late int _creditHours;
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();

    _codeCtrl = TextEditingController(text: widget.course.code);
    _nameCtrl = TextEditingController(text: widget.course.name);
    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    
    
    final updatedCourse = Course(
      _codeCtrl.text.trim().toUpperCase(),
      _nameCtrl.text.trim(),
      _creditHours,
      _day,
      widget.course.icon,
      widget.course.time,
      widget.course.venue,
      instructor: widget.course.instructor,
      isFavorite: widget.course.isFavorite,
      enrolled: widget.course.enrolled,
    );
    Navigator.pop(context, updatedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Code'),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _day,
                items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => _day = v!),
                decoration: const InputDecoration(labelText: 'Day'),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save Changes')),
            ],
          ),
        ),
      ),
    );
  }
}