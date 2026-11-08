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
  late final _nameCtrl = TextEditingController(text: widget.course.name);   // pre-filled
  late int _creditHours = widget.course.creditHours;                        // pre-filled

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final edited = widget.course.copyWith(
      name: _nameCtrl.text.trim(),
      creditHours: _creditHours,
    );
    Navigator.pop(context, edited);   // send the edited course back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Course name'),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
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
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}