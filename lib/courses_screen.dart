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
  bool _isGrid = false;
  bool _showFavoritesOnly = false;
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(Course course) {
    setState(() {
      final index = _courses.indexOf(course);
      if (index != -1) {
        _courses[index] = _courses[index].copyWith(
          isFavorite: !_courses[index].isFavorite,
        );
      }
    });
  }

  void _toggleEnrolled(Course course) {
    setState(() {
      final index = _courses.indexOf(course);
      if (index != -1) {
        _courses[index] = _courses[index].copyWith(
          enrolled: !_courses[index].enrolled,
        );
      }
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _removeCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Course?'),
        content: Text('Are you sure you want to remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
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
    
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    final shownCourses = _showFavoritesOnly
        ? _courses.where((c) => c.isFavorite).toList()
        : _courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
                '${_courses.length} courses - $totalCh credit hours\nEnrolled: $enrolledCh CH',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ Favourites only'),
                selected: _showFavoritesOnly,
                onSelected: (bool selected) {
                  setState(() {
                    _showFavoritesOnly = selected;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: shownCourses.length, 
                    itemBuilder: (context, index) {
                      final course = shownCourses[index]; 
                      return Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(course.icon, size: 40),
                              const SizedBox(height: 8),
                              Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(course.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shownCourses.length, 
                    itemBuilder: (context, index) {
                      final course = shownCourses[index]; 
                      return ListTile(
                        onLongPress: () => _removeCourse(course),
                        onTap: () async {
                          final result = await Navigator.push<Object>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(course: course),
                            ),
                          );

                          if (result == true) {
                            setState(() => _courses.remove(course));
                          } else if (result is Course) {
                            setState(() {
                              final index = _courses.indexOf(course);
                              if (index != -1) {
                                _courses[index] = result; 
                              }
                            });
                          }
                        },
                        tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                        leading: CircleAvatar(
                          backgroundColor: course.enrolled
                              ? Colors.green.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.primaryContainer,
                          child: course.enrolled
                              ? const Icon(Icons.check, color: Colors.green)
                              : Icon(course.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        title: Text(course.code),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${course.day.substring(0, 3)} ${course.time} · ${course.venue}'),
                            Text(course.instructor ?? 'TBA'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(course),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}