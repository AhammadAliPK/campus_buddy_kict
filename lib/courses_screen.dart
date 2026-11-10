import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
    });
  }

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(enrolled: !_courses[index].enrolled);
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: () => const AddCourseDialog(),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.analytics, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${_courses.length} courses - $totalCh credit hours\n'
                      'Enrolled: $enrolledCh CH',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isGrid ? _buildGrid() : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: _courses.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final course = _courses[index];
        return ListTile(
          leading: Icon(
            course.enrolled ? Icons.check_circle : course.icon,
            color: course.enrolled 
                ? Colors.green 
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          title: Text(course.code),
          subtitle: Text('${course.name} - ${course.day}'),
          trailing: IconButton(
            icon: Icon(course.isFavorite ? Icons.star : Icons.star_border),
            color: course.isFavorite ? Colors.amber : null,
            onPressed: () => _toggleFavorite(index),
          ),
          onTap: () => _toggleEnrolled(index),
        );
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        return Card(
          child: InkWell(
            onTap: () => _toggleEnrolled(index),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    course.enrolled ? Icons.check_circle : course.icon,
                    size: 32,
                    color: course.enrolled 
                        ? Colors.green 
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '${course.creditHours} CH - ${course.day}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                    icon: Icon(course.isFavorite ? Icons.star : Icons.star_border),
                    color: course.isFavorite ? Colors.amber : null,
                    onPressed: () => _toggleFavorite(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}