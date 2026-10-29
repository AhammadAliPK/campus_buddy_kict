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
  bool _isGrid = false;
  bool _favoritesOnly = false;
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  void _toggleFavorite(Course course) {
    final index = _courses.indexWhere((c) => c.code == course.code);
    if (index == -1) return;

    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(Course course) {
    final index = _courses.indexWhere((c) => c.code == course.code);
    if (index == -1) return;

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
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _confirmRemove(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text('Are you sure you want to remove ${course.code}?'),
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

    if (confirmed != true) return;

    setState(() {
      _courses.removeWhere((c) => c.code == course.code);
    });
  }

  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }
    final enrolledCh =
        _courses // ← NEW
            .where((c) => c.enrolled)
            .fold<int>(0, (sum, c) => sum + c.creditHours);

    final sortedCourses = [..._courses];

    const dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    // Start from the editable course list.
    final shown = _courses.where((c) {
      return c.day == 'Monday' && (!_favoritesOnly || c.isFavorite);
    }).toList();
    shown.sort((a, b) => dayOrder[a.day]!.compareTo(dayOrder[b.day]!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            // ← NEW: opens the Add popup
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
        // ← CHANGED
        children: [
          Card(
            // ← NEW
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
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid // ← CHANGED
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
                      return GestureDetector(
                        onLongPress: () => _confirmRemove(course),
                        child: Card(
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
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      return ListTile(
                        tileColor:
                            index
                                .isOdd // ← NEW
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course
                                    .enrolled // ← CHANGED: was course.icon
                                ? Icons.check_circle
                                : course.icon,
                            color:
                                course
                                    .enrolled // ← CHANGED
                                ? Colors.green
                                : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.day}', // ← CHANGED: day moved in here
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          // ← CHANGED: was Text(course.day)
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
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
