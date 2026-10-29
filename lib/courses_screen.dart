import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Day order for sorting and for the day filter chips
const _dayOrder = {'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5};

int _compareCourses(Course a, Course b) {
  final byDay = (_dayOrder[a.day.substring(0, 3)] ?? 9)
      .compareTo(_dayOrder[b.day.substring(0, 3)] ?? 9);
  return byDay != 0 ? byDay : a.code.compareTo(b.code);
}

String _fmt(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favOnly = false; // filter: starred only
  String? _dayFilter; // filter: one day, or null = all days
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses)..sort(_compareCourses); // our own copy
  }

  // The visible list can be filtered, so we find a course by its code
  int _indexOf(Course c) => _courses.indexWhere((x) => x.code == c.code);

  void _toggleFavorite(Course c) {
    final i = _indexOf(c);
    if (i < 0) return;
    setState(() {
      _courses[i] = _courses[i].copyWith(isFavorite: !_courses[i].isFavorite);
    });
  }

  void _toggleEnrolled(Course c) {
    final i = _indexOf(c);
    if (i < 0) return;
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
    if (course == null) return; // cancelled
    setState(() {
      _courses.add(course);
      _courses.sort(_compareCourses);
    });
  }

  Future<void> _confirmRemove(Course c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text('Are you sure you want to remove ${c.code}?'),
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
    if (ok == true) {
      setState(() => _courses.removeWhere((x) => x.code == c.code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCh = _courses.fold<double>(0, (sum, c) => sum + c.creditHours);
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<double>(0, (sum, c) => sum + c.creditHours);

    // Same _courses, just a filtered view
    final visible = _courses.where((c) {
      if (_favOnly && !c.isFavorite) return false;
      if (_dayFilter != null && !c.day.contains(_dayFilter!)) return false;
      return true;
    }).toList();

    final emptyText =
        _favOnly ? 'No favourites here yet' : 'No classes! Alhamdulillah :)';

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
            tooltip: 'Switch view',
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
                '${_courses.length} courses · ${_fmt(totalCh)} credit hours\n'
                'Enrolled: ${_fmt(enrolledCh)} CH',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ Favourites'),
                  selected: _favOnly,
                  onSelected: (v) => setState(() => _favOnly = v),
                ),
                for (final d in _dayOrder.keys) ...[
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(d),
                    selected: _dayFilter == d,
                    onSelected: (v) =>
                        setState(() => _dayFilter = v ? d : null),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? Center(child: Text(emptyText))
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final course = visible[index];
                          return Card(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    course.enrolled
                                        ? Icons.check_circle
                                        : course.icon,
                                    size: 40,
                                    color:
                                        course.enrolled ? Colors.green : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(course.code,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(course.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final course = visible[index];
                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(alpha: 0.03)
                                : null,
                            isThreeLine: true,
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
                            subtitle: Text(
                              '${course.name} · ${course.chText} CH\n'
                              '${course.day} ${course.time} · ${course.venue}\n'
                              'Lecturer: ${course.instructor ?? 'TBA'}',
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
