import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => 
  _EditCourseScreenState();
}

class _EditCourseScreenState extends
State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  late String _day;
  late int _creditHours;

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _codeCtrl.text = widget.course.code;
    _nameCtrl.text = widget.course.name;
    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save(){
    if (!_formKey.currentState!.validate()) return;
    final edited = widget.course.copyWith(
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      day: _day,
      creditHours: _creditHours,
    );
    Navigator.pop(context, edited);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Code (e.g. CSCI 4311)'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter a course code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: _day,
                items: _days.map((d) => 
                  DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setState(() => _day = v!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Credit Hours:'),
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 4,
                      divisions: 3,
                      label: '$_creditHours',
                      value: _creditHours.toDouble(),
                      onChanged: (v) => setState(() => _creditHours = v.round()),
                    ),
                  ), 
                  Text('$_creditHours'),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),    
            ],
          ),
        ),
    );
  }
}