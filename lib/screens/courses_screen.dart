import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_clear_screen.dart';

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
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return; // user cancelled
    setState(() => _courses.add(course));
  }

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _openDetail(int index) async {
    final course = _courses[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      setState(() => _courses.remove(course));
    } else if (result is Course) {
      setState(() {
        final idx = _courses.indexOf(course);
        if (idx != -1) {
          _courses[idx] = result;
        }
      });
    }
  }

  Future<void> _clearAllFavourites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmClearScreen(
          title: 'Clear All Favourites',
          message: 'Are you sure you want to clear all favourited courses?',
        ),
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        for (int i = 0; i < _courses.length; i++) {
          if (_courses[i].isFavorite) {
            _courses[i] = _courses[i].copyWith(isFavorite: false);
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All favourites cleared')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border_clear),
            tooltip: 'Clear all favourites',
            onPressed: _clearAllFavourites,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
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
                          crossAxisCount: 2, // two cards per row
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return InkWell(
                        onTap: () => _openDetail(index),
                        child: Card(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  course.enrolled
                                      ? Icons.check_circle
                                      : course.icon,
                                  size: 40,
                                  color: course.enrolled ? Colors.green : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  course.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                        leading: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _toggleEnrolled(index),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            child: Icon(
                              course.enrolled
                                  ? Icons.check_circle
                                  : course.icon,
                              color: course.enrolled
                                  ? Colors.green
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                            ),
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.day}',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color: course.isFavorite
                                ? Colors.amber
                                : null,
                          ),
                          onPressed: () => _toggleFavorite(index),
                        ),
                        onTap: () => _openDetail(index),
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
