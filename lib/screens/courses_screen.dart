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
  bool _isGrid = false; // the screen remembers which view is on
  bool _favOnly = false; // Homework 3: is the "favourites only" chip on?
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
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  // Homework 2: long-press -> "Are you sure?" -> remove
  Future<void> _confirmRemove(int index) async {
    final course = _courses[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text('Remove ${course.code} from your list?'),
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
      setState(() => _courses.remove(course));
    }
  }

  // Week 6 exercise: this one works, because _courses lives in this State
  Future<void> _clearFavourites() async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          message: 'Remove the star from every course?',
        ),
      ),
    );
    if (yes != true) return; // No, or system back (null) = do nothing
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

    // Week 4 day filter, now reading from _courses.
    // Homework 3: when the chip is on, also keep only starred courses.
    // Week 4 homework 3 (optional): sorted by day, then time
    final shown = sortedByDay(_courses
        .where((c) => c.day == 'Monday')
        .where((c) => !_favOnly || c.isFavorite)
        .toList());
    final gridCourses = sortedByDay(_courses);

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
              ),
            ),
          ),
          // Homework 3: the filter chip (the list view uses it)
          if (!_isGrid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('★ favourites only'),
                    selected: _favOnly,
                    onSelected: (v) => setState(() => _favOnly = v),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // two cards per row
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: gridCourses.length,
                    itemBuilder: (context, index) {
                      final course = gridCourses[index];
                      return Card(
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
                      );
                    },
                  )
                : shown.isEmpty
                ? Center(
                    child: Text(
                      _favOnly
                          ? 'No starred courses yet — tap a ☆ first'
                          : 'No classes! Alhamdulillah :)',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      // `index` counts rows in the FILTERED list.
                      // The toggles must change the course in _courses,
                      // so find where this course sits in the full list.
                      final realIndex = _courses.indexOf(course);
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course.enrolled ? Icons.check_circle : course.icon,
                            color: course.enrolled
                                ? Colors.green
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        // Week 4 homework: 'Mon 09:00–10:30 · LT A', and
                        // ?? shows 'TBA' when the instructor is missing
                        subtitle: Text(
                          '${course.name}\n'
                          '${course.shortDay} ${course.time} · ${course.venue}'
                          ' · ${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(realIndex),
                        ),
                        onTap: () async {
                          final result = await Navigator.push(      // ← drop the <bool>: could be bool OR Course
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(course: course),
                            ),
                          );
                          if (result == true) {
                            setState(() => _courses.remove(course));          // removed
                          } else if (result is Course) {
                            setState(() {
                              final i = _courses.indexOf(course);
                              _courses[i] = result;                            // edited → swap the row
                            });
                          }
                        },
                        onLongPress: () => _confirmRemove(realIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}