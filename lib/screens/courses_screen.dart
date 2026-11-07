import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {

  bool _isGrid = false;
  late List<Course> _courses;
  bool _favouritesOnly = false;

  static const _dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
  };

  void _sortByDay() {
    _courses.sort((a, b) => _dayOrder[a.day]!.compareTo(_dayOrder[b.day]!));
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] =
      _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
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
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _removeCourse(Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _courses.remove(course));
    }
  }

  Future<void> _clearFavourites() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(),
      ),
    );
    if (ok == true) {
      setState(() {
        for (int i = 0; i < _courses.length; i++) {
          _courses[i] = _courses[i].copyWith(isFavorite: false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
    _sortByDay();
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    final shown = _courses
        .where((c) => c.day == 'Monday')
        .where((c) => !_favouritesOnly || c.isFavorite)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Clear all favourites',
            onPressed: _clearFavourites,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid), // D. wires this up
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
                'Enrolled: $enrolledCh CH'),
            ),
          ),
          Row(
            children: [
              FilterChip(
                label: const Text('★ favourites only'),
                selected: _favouritesOnly,
                onSelected: (v) => setState(() => _favouritesOnly = v),
              ),
            ],
          ),
          Expanded(
            child: _isGrid // ← CHANGED
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // two cards per row
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return Card(
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
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            course.enrolled
                                ? Icons.check_circle
                                : course.icon,
                            color: course.enrolled
                                ? Colors.green
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.day}\n'
                          '${course.day.substring(0, 3)} ${course.time} · ${course.venue} · ${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite
                              ? Icons.star
                              : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                        onPressed: () => _toggleFavorite(_courses.indexOf(course)),
                        ),
                        onTap: () async {
                          final result = await Navigator.push<Object>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(course: course),
                            ),
                          );
                          if (result == null) return; // back = cancelled
                          if (result == true) {
                            setState(() => _courses.removeAt(_courses.indexOf(course)));
                          } else if (result is Course) {
                            setState(() => _courses[_courses.indexOf(course)] = result);
                          }
                        },
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
