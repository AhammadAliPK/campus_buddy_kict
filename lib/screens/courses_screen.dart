
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favorites_screen.dart';

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

  void _toggleFavorite(Course course) {
    final index = _courses.indexOf(course);

    if (index == -1) return;

    setState(() {
      _courses[index] = course.copyWith(
        isFavorite: !course.isFavorite,
      );
    });
  }

  Future<void> _clearAllFavorites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClearFavoritesScreen(),
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      for (int i = 0; i < _courses.length; i++) {
        _courses[i] = _courses[i].copyWith(
          isFavorite: false,
        );
      }
    });
  }

  void _toggleEnrolled(Course course) {
    final index = _courses.indexOf(course);

    if (index == -1) return;

    setState(() {
      _courses[index] = course.copyWith(
        enrolled: !course.enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => const AddCourseDialog(),
    );

    if (!mounted || course == null) return;

    setState(() {
      _courses.add(course);
    });
  }

  Future<void> _openCourseDetail(Course course) async {
    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
        ),
      ),
    );

    if (!mounted || removed != true) return;

    final index = _courses.indexOf(course);

    if (index != -1) {
      setState(() {
        _courses.removeAt(index);
      });
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
        .fold<int>(
      0,
          (sum, course) => sum + course.creditHours,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Clear all favourites',
            onPressed: _clearAllFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _addCourse,
          ),
          IconButton(
            icon: Icon(
              _isGrid ? Icons.grid_on : Icons.list,
            ),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
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
                '${_courses.length} courses · '
                    '$totalCh credit hours\n'
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
              ),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];

                return Card(
                  child: InkWell(
                    onTap: () =>
                        _openCourseDetail(course),
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            course.icon,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              course.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : ListView.builder(
              padding:
              const EdgeInsets.symmetric(vertical: 8),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];

                return ListTile(
                  tileColor: index.isOdd
                      ? Colors.black.withValues(
                    alpha: 0.03,
                  )
                      : null,
                  leading: CircleAvatar(
                    backgroundColor:
                    Theme.of(context)
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
                  title: Text(course.code),
                  subtitle: Text(
                    '${course.name} · '
                        '${course.creditHours} CH · '
                        '${course.day}',
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
                    onPressed: () =>
                        _toggleFavorite(course),
                  ),
                  onTap: () =>
                      _openCourseDetail(course),
                  onLongPress: () =>
                      _toggleEnrolled(course),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
