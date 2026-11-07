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
  late final TextEditingController _nameCtrl;
  late String _day;
  late int _creditHours;

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.course.name);
    _day = widget.course.day;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.course.copyWith(
      name: _nameCtrl.text.trim(),
      day: _day,
      creditHours: _creditHours,
    );
    Navigator.pop(context, updated);
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
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _days.contains(_day) ? _day : _days.first,
              items: _days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _day = v!),
              decoration: const InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Credit hours: '),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 4,
                    divisions: 3,
                    value: _creditHours.toDouble(),
                    label: '$_creditHours',
                    onChanged: (v) => setState(() => _creditHours = v.round()),
                  ),
                ),
                Text('$_creditHours'),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
