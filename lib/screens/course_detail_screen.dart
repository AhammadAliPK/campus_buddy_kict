import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/edit_course_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
  }

  Future<void> _editCourse() async {
    final Course? updated = await Navigator.push<Course>(
      context,
      MaterialPageRoute(
        builder: (_) => EditCourseScreen(course: _currentCourse),
      ),
    );

    // If user cancelled or backed out, do nothing
    if (updated != null) {
      setState(() => _currentCourse = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Return updated course if edited, or false if not removed
        Navigator.pop(context, _currentCourse);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentCourse.code),
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
                    _currentCourse.icon,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _currentCourse.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${_currentCourse.creditHours} credit hours • ${_currentCourse.day}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Time: ${_currentCourse.time}'),
              Text('Venue: ${_currentCourse.venue}'),
              Text('Instructor: ${_currentCourse.instructor ?? 'TBA'}'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Remove this course',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(context, 'delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
