
import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';
import 'package:campus_buddy_kict/models/course_detail_result.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<CourseDetailScreen> createState() =>
      _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }

  void _returnToCourses() {
    Navigator.pop(
      context,
      CourseDetailResult(updatedCourse: _course),
    );
  }

  Future<void> _editCourse() async {
    final updated = await Navigator.push<Course>(
      context,
      MaterialPageRoute(
        builder: (_) => EditCourseScreen(
          course: _course,
        ),
      ),
    );

    if (!mounted || updated == null) {
      return;
    }

    setState(() {
      _course = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<CourseDetailResult>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) {
          _returnToCourses();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_course.code),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Course',
              onPressed: _editCourse,
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _course.icon,
                    size: 48,
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      _course.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                '${_course.creditHours} credit hours · ${_course.day}',
              ),

              const SizedBox(height: 16),

              Text('Time: ${_course.time}'),
              Text('Venue: ${_course.venue}'),
              Text(
                'Instructor: ${_course.instructor ?? 'TBA'}',
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove this course'),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      const CourseDetailResult(removed: true),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
