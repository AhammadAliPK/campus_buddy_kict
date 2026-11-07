
import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

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

class _CourseDetailScreenState
    extends State<CourseDetailScreen> {

  late Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }

  Future<void> _editCourse() async {
    final updatedCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditCourseScreen(course: _course),
      ),
    );

    if (!mounted) return;

    if (updatedCourse != null) {
      setState(() {
        _course = updatedCourse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
  onWillPop: () async {
    Navigator.pop(context, _course);
    return false;
  },
  child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),

            onPressed: () {
              Navigator.pop(context, _course);
            },
          ),

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
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      _course.name,
                      style: Theme.of(context)
                          .textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text('${_course.creditHours} credit hours'),

              const SizedBox(height: 12),

              Text('Day: ${_course.day}'),

              const SizedBox(height: 12),

              Text('Time: ${_course.time}'),

              const SizedBox(height: 12),

              Text('Venue: ${_course.venue}'),

              const SizedBox(height: 12),

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
                    Navigator.pop(context, true);
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
