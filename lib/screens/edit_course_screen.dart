// Muhammad Naqib bin Rosli · 2310795
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key, required this.course});

  final Course course; // the course being edited (data in)

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late String _day;
  late int _creditHours;

  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
  ];

  @override
  void initState() {
    super.initState();
    // pre-fill the form from the course we were given
    _nameCtrl = TextEditingController(text: widget.course.name);
    _day = _days.contains(widget.course.day) ? widget.course.day : _days.first;
    _creditHours = widget.course.creditHours;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final edited = widget.course.copyWith(
      name: _nameCtrl.text.trim(),
      day: _day,
      creditHours: _creditHours,
    ); // star + enrolled are kept automatically
    Navigator.pop(context, edited); // answer = the edited course
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.course.code}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: widget.course.code,
              enabled: false, // the code is the course's identity
              decoration: const InputDecoration(
                labelText: 'Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Course name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _day,
              decoration: const InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
              ),
              items: _days
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _day = v!),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save changes'),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}