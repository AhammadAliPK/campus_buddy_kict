
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
  late List<Course> _courses;

  bool _isGrid = false;
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();

    // Create our own editable copy of sampleCourses
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

  // Open Add Course popup and receive the new course
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

  // Remove course after confirmation
  Future<void> _removeCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text(
          'Are you sure you want to remove ${course.code} - ${course.name}?',
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

    // Monday filter works on the editable _courses list
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
          // Add course button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _addCourse,
          ),

          // Grid/List toggle
          IconButton(
            icon: _isGrid
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ favourites only'),
                selected: _favoritesOnly,
                onSelected: (value) {
                  setState(() {
                    _favoritesOnly = value;
                  });
                },
              ),
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
                              onTap: () => _toggleEnrolled(courseIndex),
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
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Favourite star
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
                                      onPressed: () =>
                                          _toggleFavorite(courseIndex),
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

                            // Green tick when enrolled
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
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

                            // Course details
                            subtitle: Text(
                              '${course.name} · ${course.day}\n'
                              '${course.time} · ${course.venue} · '
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
                              onPressed: () =>
                                  _toggleFavorite(courseIndex),
                            ),

                            // Tap to enroll/unenroll
                            onTap: () => _toggleEnrolled(courseIndex),

                            // Long press to remove
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
