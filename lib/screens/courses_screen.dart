import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart'; // ← NEW this week
import 'package:campus_buddy_kict/add_course_dialog.dart'; // ← NEW
import 'package:campus_buddy_kict/screens/course_detail_screen.dart'; // ← NEW
import 'package:campus_buddy_kict/screens/confirm_screen.dart'; // ← NEW (exercise)

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  bool _isGrid = false; // ← NEW
  String? _dayFilter; // ← NEW (homework 1): null = all days
  bool _favOnly = false; // ← NEW (homework 3): show only starred courses

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index) {
    // ← NEW: same shape as the star
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
        existingCodes: _courses.map((c) => c.code).toList(), // ← NEW (exercise)
      ),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  // ← NEW (homework 2): long-press a row → "Are you sure?" → remove
  Future<void> _confirmRemove(Course course) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code} ${course.name}?'),
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
    if (yes != true) return; // Cancel, or tapped outside the popup
    setState(() => _courses.remove(course));
  }

  // ← NEW (exercise): works here because this screen owns _courses
  Future<void> _clearFavourites() async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          message: 'This removes the star from every course.',
        ),
      ),
    );
    if (yes != true) return; // No, or the back button (null)
    setState(() {
      _courses = [for (final c in _courses) c.copyWith(isFavorite: false)];
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
    const dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    }; // ← NEW
    final sorted =
        [..._courses] // ← CHANGED: was sampleCourses
          ..sort(
            (a, b) => (dayOrder[a.day] ?? 8).compareTo(dayOrder[b.day] ?? 8),
          );
    final shown =
        sorted // ← CHANGED (homework 1 + 3): same _courses, filtered view
            .where((c) => _dayFilter == null || c.day == _dayFilter)
            .where((c) => !_favOnly || c.isFavorite)
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            // ← NEW (exercise)
            icon: const Icon(Icons.star_border),
            tooltip: 'Clear all favourites',
            onPressed: _clearFavourites,
          ),
          IconButton(
            // ← NEW: opens the Add popup
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list), // ← CHANGED
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid), // ← CHANGED
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
                'Enrolled: $enrolledCh CH', // ← NEW: the second line
              ),
            ),
          ),
          Padding(
            // ← NEW: the filter chips (wrap onto a second line if needed)
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                FilterChip(
                  label: const Text('★ Favourites only'),
                  selected: _favOnly,
                  onSelected: (v) => setState(() => _favOnly = v),
                ),
                for (final d in [null, ...dayOrder.keys.take(5)])
                  ChoiceChip(
                    label: Text(d == null ? 'All' : d.substring(0, 3)),
                    selected: _dayFilter == d,
                    onSelected: (_) => setState(() => _dayFilter = d),
                  ),
              ],
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Text(
                      _favOnly
                          ? 'No starred courses yet'
                          : 'No classes! Alhamdulillah :)',
                    ),
                  )
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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shown.length, // ← CHANGED
                    itemBuilder: (context, index) {
                      final course = shown[index]; // ← CHANGED
                      // shown is sorted + filtered, so find this course's
                      // real position in _courses before changing it
                      final i = _courses.indexOf(course);
                      return ListTile(
                        leading: GestureDetector(
                          // ← CHANGED: row tap now opens details, so
                          // tapping the round icon enrolls instead
                          onTap: () => _toggleEnrolled(i),
                          child: CircleAvatar(
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
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.creditHours} CH\n'
                          '${course.day.substring(0, 3)} ${course.time.split('–').first} · ${course.venue} · ${course.instructor ?? 'TBA'}', // ← CHANGED: instructor moved here
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          // ← CHANGED: was Text(course.instructor ?? 'TBA')
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(i),
                        ),
                        onTap: () async {
                          // ← CHANGED: opens the detail page
                          // the answer is true (removed), an edited Course
                          // (homework 2), or null (back button)
                          final answer = await Navigator.push<Object>(
                            context,
                            MaterialPageRoute(
                              // course, not _courses[index]: the list is
                              // sorted + filtered, so index != position in _courses
                              builder: (_) =>
                                  CourseDetailScreen(course: course),
                            ),
                          );
                          if (answer == true) {
                            setState(() => _courses.remove(course));
                          } else if (answer is Course) {
                            // ← NEW (homework 2): replace that row
                            setState(() {
                              _courses[_courses.indexOf(course)] = answer;
                            });
                          }
                        },
                        onLongPress: () => _confirmRemove(course), // ← NEW
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
