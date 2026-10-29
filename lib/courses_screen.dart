import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

// Day filter from Week 4: show only this day. null = show every day.
const String? _filterDay = null;

const _dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
};

// Works for 'Monday' and for 'Tuesday/Thursday' (uses the first day found).
int _dayRank(String day) {
  var rank = 8;
  _dayOrder.forEach((name, order) {
    if (day.contains(name) && order < rank) rank = order;
  });
  return rank;
}

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favOnly = false; // Homework 3: "favourites only" chip
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  // The list on screen is a filtered view, so find the course in _courses
  // instead of trusting the row number.
  int _indexOf(Course course) => _courses.indexOf(course);

  void _toggleFavorite(Course course) {
    final i = _indexOf(course);
    setState(() {
      _courses[i] = _courses[i].copyWith(isFavorite: !_courses[i].isFavorite);
    });
  }

  void _toggleEnrolled(Course course) {
    final i = _indexOf(course);
    setState(() {
      _courses[i] = _courses[i].copyWith(enrolled: !_courses[i].enrolled);
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

  // Homework 2: long-press a row -> "Are you sure?" -> remove
  Future<void> _confirmRemove(Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text('Are you sure you want to remove ${course.code}?'),
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
    if (ok != true) return;
    setState(() => _courses.remove(course));
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

    // Day filter + favourites filter + sort by day, all on _courses
    final shown = _courses
        .where((c) => _filterDay == null || c.day.contains(_filterDay!))
        .where((c) => !_favOnly || c.isFavorite)
        .toList()
      ..sort((a, b) => _dayRank(a.day).compareTo(_dayRank(b.day)));

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
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
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
                        itemBuilder: (context, index) {
                          final course = shown[index];
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
                            title: Text(course.code),
                            isThreeLine: true,
                            subtitle: Text(
                              '${course.name} · ${course.creditHours} CH\n'
                              '${course.day} ${course.time} · '
                              '${course.venue} · ${course.instructor ?? 'TBA'}',
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () => _toggleFavorite(course),
                            ),
                            onTap: () => _toggleEnrolled(course),
                            onLongPress: () => _confirmRemove(course),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
