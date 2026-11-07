
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favourites_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> _courses;

  bool _isGrid = false;
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  // Toggle favourite status
  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  // Toggle enrollment status
  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  // Add a new course
  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );

    if (course == null || !mounted) return;

    setState(() {
      _courses.add(course);
    });
  }

  // Open course detail page
  Future<void> _openCourseDetail(Course course) async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );

    if (!mounted) return;

    setState(() {
      final index = _courses.indexOf(course);

      if (index == -1) return;

      // true means remove the course
      if (result == true) {
        _courses.removeAt(index);
      }

      // A Course object means the course was edited
      else if (result is Course) {
        _courses[index] = result;
      }
    });
  }

  // Remove course using long press
  Future<void> _removeCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text(
          'Are you sure you want to remove ${course.code}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _courses.remove(course);
      });
    }
  }

  // Clear all favourites from Courses tab
  Future<void> _clearFavourites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClearFavouritesScreen(),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _courses = _courses.map((course) {
          return course.copyWith(isFavorite: false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;

    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    // Calculate enrolled credit hours
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    // Monday filter works on the editable list
    final dayFiltered = _courses
        .where((c) => c.day == 'Monday')
        .toList();

    // Favourite filter
    final shown = dayFiltered
        .where((c) => !_favoritesOnly || c.isFavorite)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _addCourse,
          ),

          IconButton(
            icon: _isGrid
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list),
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
          // Course summary
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '${_courses.length} courses · $totalCh credit hours\n'
                  'Enrolled: $enrolledCh CH',
                ),
              ),
            ),
          ),

          // Favourite filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('★ favourites only'),
                  selected: _favoritesOnly,
                  onSelected: (value) {
                    setState(() {
                      _favoritesOnly = value;
                    });
                  },
                ),

                TextButton.icon(
                  onPressed: _clearFavourites,
                  icon: const Icon(Icons.star_border),
                  label: const Text('Clear favourites'),
                ),
              ],
            ),
          ),

          // Course list or grid
          Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text('No classes! Alhamdulillah :)'),
                  )
                : _isGrid
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
                          final courseIndex = _courses.indexOf(course);

                          return Card(
                            child: InkWell(
                              onTap: () => _openCourseDetail(course),
                              onLongPress: () => _removeCourse(course),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          course.enrolled
                                              ? Icons.check_circle
                                              : course.icon,
                                          size: 40,
                                          color: course.enrolled
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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

                                        Text(
                                          '${course.day} · ${course.time}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        course.isFavorite
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: course.isFavorite
                                            ? Colors.amber
                                            : null,
                                      ),
                                      onPressed: () {
                                        _toggleFavorite(courseIndex);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          final courseIndex = _courses.indexOf(course);

                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(alpha: 0.03)
                                : null,

                            leading: CircleAvatar(
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

                            title: Text(course.code),

                            subtitle: Text(
                              '${course.name} · ${course.day}\n'
                              '${course.time} · ${course.venue} · '
                              '${course.instructor ?? 'TBA'}',
                            ),

                            isThreeLine: true,

                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite
                                    ? Colors.amber
                                    : null,
                              ),
                              onPressed: () {
                                _toggleFavorite(courseIndex);
                              },
                            ),

                            onTap: () => _openCourseDetail(course),

                            onLongPress: () => _removeCourse(course),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
