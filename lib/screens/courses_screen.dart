import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool isGrid = false;
  bool showFavoritesOnly = false;
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  Future<void> addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (context) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _confirmRemoveCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Course'),
        content: Text('Are you sure you want to remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _courses.removeWhere((c) => c.code == course.code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    final displayedCourses = showFavoritesOnly
        ? _courses.where((c) => c.isFavorite).toList()
        : _courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addCourse,
          ),
          IconButton(
            icon: isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => isGrid = !isGrid),
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
                '${_courses.length} courses ($totalCh credit hours)',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ favourites only'),
                  selected: showFavoritesOnly,
                  onSelected: (selected) {
                    setState(() {
                      showFavoritesOnly = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedCourses.isEmpty
                ? const Center(
                    child: Text('No courses found'),
                  )
                : isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: displayedCourses.length,
                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];
                          return Card(
                            child: InkWell(
                              onLongPress: () => _confirmRemoveCourse(course),
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
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: displayedCourses.length,
                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];
                          final originalIndex = _courses.indexOf(course);

                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(alpha: 0.03)
                                : null,
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                course.icon,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                            title: Text(course.code),
                            subtitle: Text('${course.name} (${course.day})'),
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                              color: course.isFavorite ? Colors.amber : null,
                              onPressed: () => toggleFavorite(originalIndex),
                            ),
                            onTap: () async {
                              final result = await Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetailScreen(course: course),
                                ),
                              );

                              if (result == true) {
                                setState(() {
                                  _courses.removeWhere(
                                      (c) => c.code == course.code);
                                });
                              } else if (result is Course) {
                                setState(() {
                                  final targetIndex = _courses
                                      .indexWhere((c) => c.code == course.code);
                                  if (targetIndex != -1) {
                                    _courses[targetIndex] = result;
                                  }
                                });
                              }
                            },
                            onLongPress: () => _confirmRemoveCourse(course),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}