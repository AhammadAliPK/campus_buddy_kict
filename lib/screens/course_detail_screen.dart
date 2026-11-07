
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

class _CourseDetailScreenState extends State<CourseDetailScreen> {
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
        builder: (_) => EditCourseScreen(course: _course),
      ),
    );

    if (updatedCourse == null || !mounted) return;

    setState(() {
      _course = updatedCourse;
    });
  }

  void _toggleEnrolled() {
    setState(() {
      _course = _course.copyWith(
        enrolled: !_course.enrolled,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _course);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_course.code),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _course);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit course',
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
                      style: Theme.of(context).textTheme.headlineSmall,
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

              Text('Instructor: ${_course.instructor ?? 'TBA'}'),
              const SizedBox(height: 12),

              Text(
                'Favourite: ${_course.isFavorite ? 'Yes' : 'No'}',
              ),
              const SizedBox(height: 12),

              Text(
                'Enrolled: ${_course.enrolled ? 'Yes' : 'No'}',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _toggleEnrolled,
                  icon: Icon(
                    _course.enrolled
                        ? Icons.remove_circle_outline
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    _course.enrolled ? 'Unenroll' : 'Enroll',
                  ),
                ),
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
