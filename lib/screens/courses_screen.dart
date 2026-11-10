// Muhammad Naqib bin Rosli · 2310795
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

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
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

  // Detail page can answer: true (remove), a Course (edited), or null (back)
  Future<void> _openDetail(int index) async {
    final course = _courses[index]; // capture BEFORE await
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );
    if (result == true) {
      setState(() => _courses.remove(course));
    } else if (result is Course) {
      // HW Part 2: replace that row with the edited course
      setState(() {
        final i = _courses.indexOf(course);
        if (i != -1) _courses[i] = result;
      });
    }
    // result == null -> back pressed -> nothing changes (Part 3)
  }

  Future<void> _clearFavorites() async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ConfirmScreen(message: 'Clear all favourites?'),
      ),
    );
    if (yes != true) return;
    setState(() {
      _courses = _courses.map((c) => c.copyWith(isFavorite: false)).toList();
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
            icon: const Icon(Icons.star_border),
            tooltip: 'Clear all favourites',
            onPressed: _clearFavorites,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
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
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
                textAlign: TextAlign.center,
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
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return Card(
                        child: InkWell(
                          onTap: () => _openDetail(index),
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
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: GestureDetector(
                          onTap: () => _toggleEnrolled(index),
                          child: CircleAvatar(
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
                        ),
                        title: Text(course.code),
                        subtitle: Text('${course.name} · ${course.day}'),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(index),
                        ),
                        onTap: () => _openDetail(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}