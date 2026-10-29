import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class AddCourseDialog extends StatefulWidget {
  const AddCourseDialog({super.key});

  @override
  State<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  
  String _day = 'Monday';
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  
  int _creditHours = 3;
  String? _errorMessage;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _codeCtrl.text.trim().toUpperCase();
    final name = _nameCtrl.text.trim();

    if (code.isEmpty) {
      setState(() => _errorMessage = 'Code is required');
      return;
    }
    if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(code)) {
      setState(() => _errorMessage = 'Format: 4 letters + 4 digits (e.g. CSCI 4311)');
      return;
    }
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Course name is required');
      return;
    }

    final course = Course(
      code,
      name,
      _creditHours,
      _day,
      Icons.auto_stories,
    );

    Navigator.pop(context, course);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Add a course'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: _codeCtrl,
                placeholder: 'Code (e.g. CSCI 4311)',
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _nameCtrl,
                placeholder: 'Course name',
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Day:', style: TextStyle(fontSize: 14)),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(_day),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => Container(
                          height: 200,
                          color: CupertinoColors.systemBackground.resolveFrom(context),
                          child: CupertinoPicker(
                            itemExtent: 32,
                            onSelectedItemChanged: (index) {
                              setState(() => _day = _days[index]);
                            },
                            children: _days.map((d) => Text(d)).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Credit Hours:', style: TextStyle(fontSize: 14)),
                  Text('$_creditHours CH', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              CupertinoSlider(
                min: 1,
                max: 4,
                divisions: 3,
                value: _creditHours.toDouble(),
                onChanged: (v) => setState(() => _creditHours = v.round()),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: CupertinoColors.destructiveRed, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}