import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;
  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeCtrl;
  late TextEditingController _nameCtrl;
  late String _day;
  late int _creditHours;

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    // Homework: Pre-fill the form with existing data
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    // Homework: Returns a modified copy keeping existing favorite/enrolled states
    final edited = widget.course.copyWith(
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      creditHours: _creditHours,
      day: _day,
    );
    Navigator.pop(context, edited);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _codeCtrl,
                  decoration: const InputDecoration(labelText: 'Code'),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Code is required' : null,
                ),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Course name'),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _day,
                  items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => setState(() => _day = v!),
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
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}