import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_clear_favorites_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  late List<Course> _courses;
  bool _showFavoritesOnly = false; 
  String _selectedDay = 'All';   

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); 
  }

  void _toggleFavorite(Course course) {
    final index = _courses.indexWhere((c) => c.code == course.code);
    if (index != -1) {
      setState(() {
        _courses[index] = _courses[index].copyWith(
          isFavorite: !_courses[index].isFavorite,
        );
      });
    }
  }

  void _toggleEnrolled(Course course) {
    final index = _courses.indexWhere((c) => c.code == course.code);
    if (index != -1) {
      setState(() {
        _courses[index] = _courses[index].copyWith(
          enrolled: !_courses[index].enrolled,
        );
      });
    }
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

  Future<void> _confirmDeleteCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Course'),
        content: Text('Are you sure you want to remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _courses.removeWhere((c) => c.code == course.code);
      });
    }
  }

  Future<void> _clearAllFavorites() async {
  final confirmed = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => const ConfirmClearFavoritesScreen(),
    ),
  );

  if (confirmed == true) {
    setState(() {
      _courses = _courses.map((c) => c.copyWith(isFavorite: false)).toList();
    });
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
        .fold(0, (sum, c) => sum + c.creditHours);

    List<Course> displayedCourses = _courses;

    if (_selectedDay != 'All') {
      displayedCourses =
          displayedCourses.where((c) => c.day == _selectedDay).toList();
    }

    if (_showFavoritesOnly) {
      displayedCourses =
          displayedCourses.where((c) => c.isFavorite).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            tooltip: 'Clear all favorites',
            onPressed: _clearAllFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addCourse,
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
              child: Text('${_courses.length} courses $totalCh credit hours\n''Enrolled: $enrolledCh CH',
              ),
            ),
          ),

        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ Favorites only'),
                  selected: _showFavoritesOnly,
                  onSelected: (val) =>
                      setState(() => _showFavoritesOnly = val),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedDay,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Days')),
                    DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                    DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
                    DropdownMenuItem(value: 'Wednesday', child: Text('Wednesday')),
                    DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
                    DropdownMenuItem(value: 'Friday', child: Text('Friday')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDay = val);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: displayedCourses.isEmpty
                ? const Center(child: Text('No courses found!'))
                : (_isGrid
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
                          return InkWell(
                            onLongPress: () => _confirmDeleteCourse(course),

                            onTap: () async {
                              final result = await Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailScreen(course: course),
                                ),
                              );

                              if (result == 'delete') {
                                setState(() {
                                  _courses.removeWhere((c) => c.code == course.code);
                                });
                              } else if (result is Course) {
                                setState(() {
                                  final index = _courses.indexWhere((c) => c.code == course.code);
                                  if (index != -1) {
                                    _courses[index] = result;
                                  }
                                });
                              }
                            },
                
                            child: Card(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(course.icon, size: 40),
                                    const SizedBox(height: 8),
                                    Text(course.code,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(course.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
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

                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(alpha: 0.03)
                                : null,
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: course.enrolled,
                                  onChanged: (_) => _toggleEnrolled(course),
                                ),
                                CircleAvatar(
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
                              ],
                            ),
                            title: Text(course.code),
                            subtitle: Text('${course.name} · (${course.day})'),
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () => _toggleFavorite(course),
                            ),
                            onTap: () async {
                              final result = await Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailScreen(course: course),
                                ),
                              );

                              if (result == 'delete') {
                                setState(() {
                                  _courses.removeWhere((c) => c.code == course.code);
                                });
                              } else if (result is Course) {
                                setState(() {
                                  final index = _courses.indexWhere((c) => c.code == course.code);
                                  if (index != -1) {
                                    _courses[index] = result;
                                  }
                                });
                              }
                            },
                            onLongPress: () => _confirmDeleteCourse(course),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }
}