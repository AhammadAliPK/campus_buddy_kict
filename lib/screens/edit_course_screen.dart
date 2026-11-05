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
  late final TextEditingController _nameCtrl;
  late final TextEditingController _lecturerCtrl;
  late String _day;
  late int _creditHours;
  static const _days = ['Monday','Tuesday','Wednesday','Thursday','Friday'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.course.name);
    _lecturerCtrl = TextEditingController(text: widget.course.lecturer);
    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lecturerCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, widget.course.copyWith(
      name: _nameCtrl.text.trim(),
      lecturer: _lecturerCtrl.text.trim(),
      day: _day,
      creditHours: _creditHours,
    ));
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
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
            ),
            TextFormField(
              controller: _lecturerCtrl,
              decoration: const InputDecoration(labelText: 'Lecturer'),
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Lecturer is required' : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(labelText: 'Day'),
              items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _day = v!),
            ),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Credit hours'),
              Expanded(child: Slider(
                min: 1, max: 4, divisions: 3, label: '$_creditHours',
                value: _creditHours.toDouble(),
                onChanged: (v) => setState(() => _creditHours = v.round()),
              )),
              Text('$_creditHours'),
            ]),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Save')),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}
