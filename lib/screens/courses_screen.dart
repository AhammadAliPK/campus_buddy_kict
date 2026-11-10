import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:flutter/material.dart';

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
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((course) => course.code).toList(),
      ),
    );

    if (course == null) {
      return;
    }

    setState(() => _courses.add(course));
  }

  Future<void> _openCourse(int index) async {
    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: _courses[index]),
      ),
    );

    if (removed == true) {
      setState(() => _courses.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final course in _courses) {
      totalCh += course.creditHours;
    }

    final enrolledCh = _courses
        .where((course) => course.enrolled)
        .fold<int>(0, (sum, course) => sum + course.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _addCourse,
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
              ),
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _openCourse(index),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      course.enrolled
                                          ? Icons.check_circle
                                          : course.icon,
                                      size: 28,
                                      color: course.enrolled
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _toggleFavorite(index),
                                      icon: Icon(
                                        course.isFavorite
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: course.isFavorite
                                            ? Colors.amber
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  course.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    course.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${course.creditHours} CH'),
                                    Checkbox(
                                      value: course.enrolled,
                                      onChanged: (_) => _toggleEnrolled(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course.enrolled ? Icons.check_circle : course.icon,
                            color: course.enrolled
                                ? Colors.green
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(course.code)),
                            IconButton(
                              onPressed: () => _toggleFavorite(index),
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${course.name} · ${course.day}',
                        ),
                        trailing: Checkbox(
                          value: course.enrolled,
                          onChanged: (_) => _toggleEnrolled(index),
                        ),
                        onTap: () => _openCourse(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}