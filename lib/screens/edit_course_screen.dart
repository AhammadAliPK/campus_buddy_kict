import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

/// Form pre-filled from [course]. Pops the edited Course on Save;
/// system back pops null (cancelled).
class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.course.name);
  late final _creditCtrl = TextEditingController(
      text: widget.course.creditHours == widget.course.creditHours.truncate()
          ? '${widget.course.creditHours.toInt()}'
          : '${widget.course.creditHours}');
  late final _dayCtrl = TextEditingController(text: widget.course.day);
  late final _timeCtrl = TextEditingController(text: widget.course.time);
  late final _venueCtrl = TextEditingController(text: widget.course.venue);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _creditCtrl.dispose();
    _dayCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        widget.course.copyWith(
          name: _nameCtrl.text.trim(),
          creditHours: double.parse(_creditCtrl.text.trim()),
          day: _dayCtrl.text.trim(),
          time: _timeCtrl.text.trim(),
          venue: _venueCtrl.text.trim(),
        ),
      );
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.course.code}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: _required,
              ),
              TextFormField(
                controller: _creditCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Credit hours'),
                validator: (value) {
                  final ch = double.tryParse(value?.trim() ?? '');
                  if (ch == null) return 'Enter a number, e.g. 3';
                  if (ch <= 0 || ch > 6) return 'Between 0.5 and 6';
                  return null;
                },
              ),
              TextFormField(
                controller: _dayCtrl,
                decoration: const InputDecoration(labelText: 'Day'),
                validator: _required,
              ),
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(labelText: 'Time'),
                validator: _required,
              ),
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(labelText: 'Venue'),
                validator: _required,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
