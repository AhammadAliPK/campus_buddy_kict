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
  bool _favoritesOnly = false;

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
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  Future<void> _clearFavorites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ClearFavoritesScreen()),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      for (int i = 0; i < _courses.length; i++) {
        _courses[i] = _courses[i].copyWith(isFavorite: false);
      }
    });
  }

  void _toggleEnrolled(Course course) {
    final index = _courses.indexOf(course);

    if (index == -1) return;

    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _deleteCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _courses.remove(course);
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );

    if (course == null || !mounted) return;

    setState(() {
      _courses.add(course);
    });
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

    // Sort courses by day (Week 4 homework)
    final dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    final shown = _courses
        .where((c) => !_favoritesOnly || c.isFavorite)
        .toList();

    shown.sort((a, b) {
      return (dayOrder[a.day] ?? 8).compareTo(dayOrder[b.day] ?? 8);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Clear all favourites',
            onPressed: _clearFavorites,
          ),

          IconButton(icon: const Icon(Icons.add), onPressed: _addCourse),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('Favourites only'),
                avatar: const Icon(Icons.star, size: 18),
                selected: _favoritesOnly,
                onSelected: (value) {
                  setState(() {
                    _favoritesOnly = value;
                  });
                },
              ),
            ),
          ),

          // Summary Card
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
                        ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];

                      return Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(course.icon, size: 40),
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
                      );
                    },
                  )
                : shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];

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
                                : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                          ),
                        ),

                        title: Text(course.code),

                        subtitle: Text(
                          '${course.name} · '
                          '${course.day.substring(0, 3)} '
                          '${course.time} · ${course.venue}\n'
                          'Instructor: ${course.instructor ?? 'TBA'}',
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                course.enrolled
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: course.enrolled ? Colors.green : null,
                              ),
                              tooltip: course.enrolled
                                  ? 'Unenroll from course'
                                  : 'Enroll in course',
                              onPressed: () => _toggleEnrolled(course),
                            ),
                            IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              tooltip: 'Toggle favourite',
                              onPressed: () => _toggleFavorite(course),
                            ),
                          ],
                        ),

                        // Week 5 Step 15: Toggle enrollment
                        onTap: () async {
                          final selectedCourse = course;

                          final result = await Navigator.push<Object?>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailScreen(course: selectedCourse),
                            ),
                          );

                          if (!mounted) return;

                          final courseIndex = _courses.indexOf(selectedCourse);

                          if (courseIndex == -1) return;

                          if (result == true) {
                            setState(() {
                              _courses.removeAt(courseIndex);
                            });
                          } else if (result is Course) {
                            setState(() {
                              _courses[courseIndex] = result;
                            });
                          }
                        },

                        onLongPress: () => _deleteCourse(course),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
