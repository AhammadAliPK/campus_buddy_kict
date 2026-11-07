
import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/confirmation_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favouritesOnly = false;

  late List<Course> _courses;

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

  // Toggle enrolment status
  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  // Add new course
  Future<void> _openAddDialog() async {
    final newCourse = await showDialog<Course>(
      context: context,
      builder: (context) {
        return AddCourseDialog(
          existingCodes: _courses.map((c) => c.code).toList(),
        );
      },
    );

    if (!mounted || newCourse == null) return;

    setState(() {
      _courses.add(newCourse);
      _favouritesOnly = false;
    });
  }

  // Open course detail and receive the result
  Future<void> _openCourseDetail(Course course) async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CourseDetailScreen(course: course);
        },
      ),
    );

    if (!mounted) return;

    final originalIndex = _courses.indexOf(course);

    if (originalIndex == -1) return;

    if (result == true) {
      // Remove course
      setState(() {
        _courses.removeAt(originalIndex);
      });
    } else if (result is Course) {
      // Replace course with edited course
      setState(() {
        _courses[originalIndex] = result;
      });
    }
  }

  // Remove course
  Future<void> _removeCourse(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Course?'),

          content: Text(
            'Are you sure you want to remove ${_courses[index].code}?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirm == true) {
      setState(() {
        _courses.removeAt(index);
      });
    }
  }

  // Clear all favourites using a full confirmation screen
  Future<void> _clearAllFavourites() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ConfirmationScreen();
        },
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _courses = _courses.map((course) {
          return course.copyWith(isFavorite: false);
        }).toList();

        _favouritesOnly = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All favourites have been cleared.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    // Calculate total credit hours
    final totalCh = _courses.fold<int>(
      0,
      (sum, course) => sum + course.creditHours,
    );

    // Calculate enrolled credit hours
    final enrolledCh = _courses
        .where((course) => course.enrolled)
        .fold<int>(
          0,
          (sum, course) => sum + course.creditHours,
        );

    // Filter favourite courses
    final displayedCourses = _courses
        .where((course) =>
            !_favouritesOnly || course.isFavorite)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),

        actions: [
          // Clear favourites
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all favourites',
            onPressed: _clearAllFavourites,
          ),

          // Add course
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _openAddDialog,
          ),

          // Grid and list view
          IconButton(
            icon: Icon(
              _isGrid ? Icons.list : Icons.grid_on,
            ),
            tooltip: 'Change view',

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
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    '${_courses.length} courses · $totalCh credit hours',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Enrolled: $enrolledCh CH',
                  ),
                ],
              ),
            ),
          ),

          // Favourite filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ Favourites only'),
                  selected: _favouritesOnly,

                  onSelected: (selected) {
                    setState(() {
                      _favouritesOnly = selected;
                    });
                  },
                ),
              ],
            ),
          ),

          // Course list or grid
          Expanded(
            child: displayedCourses.isEmpty

                ? Center(
                    child: Text(
                      _courses.isEmpty
                          ? 'No classes! Alhamdulillah :)'
                          : 'No favourite courses found.',
                    ),
                  )

                : _isGrid

                    // GRID VIEW
                    ? GridView.builder(
                        padding: const EdgeInsets.all(12),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),

                        itemCount: displayedCourses.length,

                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];
                          final originalIndex = _courses.indexOf(course);

                          return Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),

                              onTap: () {
                                _openCourseDetail(course);
                              },

                              child: Padding(
                                padding: const EdgeInsets.all(12),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          course.icon,
                                          size: 28,
                                        ),

                                        const Spacer(),

                                        IconButton(
                                          icon: Icon(
                                            course.isFavorite
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: course.isFavorite
                                                ? Colors.amber
                                                : null,
                                          ),

                                          onPressed: () {
                                            _toggleFavorite(originalIndex);
                                          },
                                        ),
                                      ],
                                    ),

                                    Text(
                                      course.code,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      course.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const Spacer(),

                                    Text(
                                      '${course.creditHours} Credit Hours',
                                    ),

                                    Text(course.day),

                                    const SizedBox(height: 4),

                                    Row(
                                      children: [
                                        Checkbox(
                                          value: course.enrolled,

                                          onChanged: (_) {
                                            _toggleEnrolled(originalIndex);
                                          },
                                        ),

                                        const Expanded(
                                          child: Text(
                                            'Enrolled',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),

                                          onPressed: () {
                                            _removeCourse(originalIndex);
                                          },
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

                    // LIST VIEW
                    : ListView.builder(
                        itemCount: displayedCourses.length,

                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];
                          final originalIndex = _courses.indexOf(course);

                          return ListTile(
                            leading: course.enrolled
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(course.icon),

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

                              onPressed: () {
                                _toggleFavorite(originalIndex);
                              },
                            ),

                            onTap: () {
                              _openCourseDetail(course);
                            },

                            onLongPress: () {
                              _removeCourse(originalIndex);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
