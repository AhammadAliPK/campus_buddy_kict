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
  String _day = 'All';
  bool _favOnly = false; // NEW: "★ favourites only" chip state
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  late List<Course> _courses; // FIX: field was never declared

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavourite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavourite: !_courses[index].isFavourite,
      );
    });
  }

  Future<void> _addCourse() async {
    // ← CHANGED: was _openAddDialog
    final course = await showDialog<Course>(
      context: context,
      // NEW: pass current codes so dialog can reject duplicates (no const: list built at runtime)
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  // NEW: long-press -> confirm -> remove
  Future<void> _removeCourse(Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false), // NEW: cancel -> false
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true), // NEW: confirm -> true
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok != true) return; // NEW: null = tapped outside, treat as cancel
    setState(() => _courses.remove(course)); // NEW: remove by object, safe with filtered/sorted view
  }

  void _toggleEnrolled(int index) {
    // ← NEW: same shape as the star
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in _courses) {
      // ← NEW
      totalCh = totalCh + c.creditHours; // ← NEW
    } // ← NEW
    final enrolledCh =
        _courses // ← NEW
            .where((c) => c.enrolled)
            .fold<int>(0, (sum, c) => sum + c.creditHours);
    // NEW: favourites filter applied first, then day filter (same _courses, just a view)
    final base = _favOnly
        ? _courses.where((c) => c.isFavourite).toList()
        : _courses;
    final shown = _day == 'All'
        ? ([...base]..sort(
            // FIX: was sampleCourses, so added/toggled courses ignored
            (a, b) => _days.indexOf(a.days.first) - _days.indexOf(b.days.first),
          ))
        : base.where((c) => c.days.contains(_day)).toList(); // CHANGED: _courses -> base
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse, // ← NEW
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () =>
                setState(() => _isGrid = !_isGrid), // D. wires this up
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final d in ['All', ..._days])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(d.substring(0, 3)),
                      selected: _day == d,
                      onSelected: (_) => setState(() => _day = d),
                    ),
                  ),
              ],
            ),
          ),
          // NEW: second chip row, favourites only toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ favourites only'),
                selected: _favOnly,
                onSelected: (on) => setState(() => _favOnly = on),
              ),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Text(
                      _favOnly
                          ? 'No starred courses' // NEW: clearer message when fav filter on
                          : 'No classes! Alhamdulillah :)',
                    ),
                  )
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 240,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: shown
                        .length, // FIX: render filtered list so day chips work
                    itemBuilder: (context, index) {
                      final course = shown[index]; // FIX: same
                      final realIndex = _courses.indexOf(course); // FIX: shown is sorted/filtered, find position in _courses
                      return Card(
                        child: InkWell(
                          onTap: () => _toggleEnrolled(
                            realIndex,
                          ), // FIX: use realIndex, not shown index
                          onLongPress: () => _removeCourse(course), // NEW: long-press card to remove
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  course.enrolled
                                      ? Icons.check_circle
                                      : course.icon, // FIX: show enrolled state in grid too
                                  size: 28,
                                  color: course.enrolled ? Colors.green : null,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  course.code,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${course.creditHours} CH', //· ${course.days.map((d) => d.substring(0, 3)).join(', ')}
                                ),
                                Text(
                                  course.time,
                                ), // FIX: no need '${}' for plain String (lint)
                                Text(course.venue), // FIX: same
                                Center(
                                  child: Text(
                                    course.instructor ?? 'TBA',
                                    textAlign: TextAlign.center,
                                  ),
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
                    itemCount: shown
                        .length, // FIX: render filtered list so day chips work
                    itemBuilder: (context, index) {
                      final course = shown[index]; // FIX: same
                      final realIndex = _courses.indexOf(course); // FIX: shown is sorted/filtered, find position in _courses
                      return ListTile(
                        tileColor: index.isOdd
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
                        isThreeLine: true,
                        subtitle: Text(
                          '${course.name} \n' // FIX: CH label had days instead of creditHours
                          '${course.creditHours} CH · ${course.time} \n'
                          '${course.venue}\n'
                          '${course.instructor ?? 'TBA'}',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavourite ? Icons.star : Icons.star_border,
                            color: course.isFavourite
                                ? Colors.amber
                                : null, // FIX: typo isFavourtie
                          ),
                          onPressed: () => _toggleFavourite(realIndex), // FIX: moved inside IconButton (ListTile has no onPressed), pass index not IndexError
                        ),
                        onTap: () =>
                            _toggleEnrolled(realIndex), // FIX: use realIndex
                        onLongPress: () => _removeCourse(course), // NEW: long-press row to remove
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
