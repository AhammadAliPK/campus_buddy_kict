import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // ← NEW: needed for Material
import 'package:campus_buddy_kict/models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(course.code),
      ),
      // FIX: gives all Text below a default style (no red/yellow text)
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      course.icon,
                      size: 48,
                      color: CupertinoColors.activeBlue,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        course.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          // follows light/dark mode properly
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${course.creditHours} credit hours • ${course.day}',
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Remove this course'),
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