import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favOnly = false;
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

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );
    if (course == null) return; // the user cancelled
    setState(() => _courses.add(course));
  }

  Future<void> _confirmRemove(int index) async {
    final course = _courses[index];
    final sure = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code} from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (sure != true) return;
    setState(() => _courses.removeAt(index));
  }

  // Week 6: open the detail page. It answers true (remove) or an edited Course.
  Future<void> _openDetail(Course course) async {
    final result = await Navigator.push<Object>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
          existingCodes: _courses.map((c) => c.code).toList(),
        ),
      ),
    );
    if (!mounted) return;
    // Find the course again by object, not by the old position.
    final i = _courses.indexOf(course);
    if (i < 0) return;
    if (result == true) {
      setState(() => _courses.removeAt(i));
    } else if (result is Course) {
      setState(() => _courses[i] = result);
    }
    // Back button = null = nothing changes.
  }

  // Week 6 exercise: clear all stars, after a full confirmation screen.
  Future<void> _clearFavourites() async {
    final sure = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          title: 'Clear favourites',
          message: 'Are you sure? Every starred course loses its star.',
        ),
      ),
    );
    if (sure != true) return;
    setState(() {
      _courses = [for (final c in _courses) c.copyWith(isFavorite: false)];
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

    // Positions in _courses that are shown (all, or starred only).
    // Keeping real positions means star / enroll / remove hit the right course.
    final shown = [
      for (var i = 0; i < _courses.length; i++)
        if (!_favOnly || _courses[i].isFavorite) i,
    ];

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
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          IconButton(
            icon: const Icon(Icons.star_half),
            tooltip: 'Clear all favourites',
            onPressed: _clearFavourites,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ favourites only'),
                selected: _favOnly,
                onSelected: (v) => setState(() => _favOnly = v),
              ),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No courses to show'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // two cards per row
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: shown.length,
                    itemBuilder: (context, i) {
                      final index = shown[i];
                      final course = _courses[index];
                      return Card(
                        child: InkWell(
                          onTap: () => _openDetail(course),
                          onLongPress: () => _confirmRemove(index),
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
                    itemCount: shown.length,
                    itemBuilder: (context, i) {
                      final index = shown[i];
                      final course = _courses[index];
                      return ListTile(
                        // Tap the round icon to enroll (the row itself opens the detail page).
                        leading: GestureDetector(
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
                        tileColor: i.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        subtitle: Text('${course.name} · ${course.day}'),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(index),
                        ),
                        onTap: () => _openDetail(course),
                        onLongPress: () => _confirmRemove(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
