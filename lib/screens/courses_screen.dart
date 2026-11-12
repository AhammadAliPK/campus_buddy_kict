
import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favorites_screen.dart';
import 'package:campus_buddy_kict/models/course_detail_result.dart';

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

  // Toggle favourite status
  void _toggleFavorite(Course course) {
    final index = _courses.indexOf(course);

    if (index == -1) return;

    setState(() {
      _courses[index] = course.copyWith(
        isFavorite: !course.isFavorite,
      );
    });
  }

  // Toggle enrollment status (Week 5)
  

  // Remove a course with confirmation
  Future<void> _removeCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text(
          'Are you sure you want to remove ${course.code}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) {
      return;
    }

    setState(() {
      _courses.remove(course);
    });
  }

  // Week 6: Open the course detail page
  Future<void> _openCourseDetail(Course course) async {
    final result = await Navigator.push<CourseDetailResult>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );

    if (!mounted || result == null) return;

    final index = _courses.indexOf(course);
    if (index == -1) return;

    setState(() {
      if (result.removed) {
        _courses.removeAt(index);
      } else if (result.updatedCourse != null) {
        _courses[index] = result.updatedCourse!;
      }
    });
  }



  // week6: clear Favourites
  Future<void> _clearAllFavorites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClearFavoritesScreen(),
      ),
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      for (int i = 0; i < _courses.length; i++) {
        _courses[i] = _courses[i].copyWith(
          isFavorite: false,
        );
      }
    });
  }


  // Week 5: Add a new course
  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses
            .map((c) => c.code)
            .toSet(),
      ),
    );

    if (!mounted || course == null) {
      return;
    }

    setState(() {
      _courses.add(course);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Total credit hours
    final totalCh = _courses.fold<int>(
      0,
      (sum, course) => sum + course.creditHours,
    );

    // Enrolled credit hours
    final enrolledCh = _courses
        .where((course) => course.enrolled)
        .fold<int>(
          0,
          (sum, course) => sum + course.creditHours,
        );

    // List View: Monday courses + favourites filter
    final shown = _courses.where((course) {
      final matchesDay = course.day == 'Monday';
      final matchesFavorite =
          !_favoritesOnly || course.isFavorite;

      return matchesDay && matchesFavorite;
    }).toList();

    // Grid View: all days + favourites filter
    final gridShown = _courses.where((course) {
      return !_favoritesOnly || course.isFavorite;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          // Clear favorite button
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all favourites',
            onPressed: _clearAllFavorites,
          ),
          // Add course button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _addCourse,
          ),

          // Switch between Grid and List
          IconButton(
            icon: Icon(
              _isGrid ? Icons.list : Icons.grid_on,
            ),
            tooltip: _isGrid
                ? 'Switch to List View'
                : 'Switch to Grid View',
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
          // Summary card
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

          // Favourites-only filter
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ Favourites only'),
                selected: _favoritesOnly,
                onSelected: (selected) {
                  setState(() {
                    _favoritesOnly = selected;
                  });
                },
              ),
            ),
          ),

          // Grid View or List View
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: gridShown.length,
                    itemBuilder: (context, index) {
                      final course = gridShown[index];

                      return Card(
                        child: InkWell(
                          onTap: () => _openCourseDetail(course),
                          onLongPress: () => _removeCourse(course),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  course.icon,
                                  size: 32,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  course.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  '${course.day} ${course.time}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),

                                Text(
                                  course.venue,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),

                                Text(
                                  'Instructor: '
                                  '${course.instructor ?? 'TBA'}',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )

                // List View empty message
                : shown.isEmpty
                    ? Center(
                        child: Text(
                          _favoritesOnly
                              ? 'No favourite Monday courses yet.'
                              : 'No classes! Alhamdulillah :)',
                        ),
                      )

                    // List View
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];

                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(
                                    alpha: 0.03,
                                  )
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

                            title: Text(
                              '${course.code} - ${course.name}',
                            ),

                            subtitle: Text(
                              '${course.day} ${course.time} '
                              '· ${course.venue}\n'
                              'Instructor: '
                              '${course.instructor ?? 'TBA'}',
                            ),

                            isThreeLine: true,

                            // Favourite star
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
                                _toggleFavorite(course);
                              },
                            ),

                            // Week 6: Open detail page
                            onTap: () {
                              _openCourseDetail(course);
                            },

                            // Week 5: Long press to remove
                            onLongPress: () {
                              _removeCourse(course);
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
