import 'package:flutter/cupertino.dart';
import 'package:campus_buddy_kict/models/course.dart'; // Fixed import path

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(course.code),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(course.icon, size: 48, color: CupertinoColors.activeBlue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      course.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${course.creditHours} credit hours • ${course.day}',
                style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: const Text('Remove this course'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}