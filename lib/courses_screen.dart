import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;

  // sampleCourses is const (frozen), so work on a copy we may change.
  List<Course> _courses = List.of(sampleCourses);

  // "Which day am I free?" — null shows every course.
  String? _dayFilter;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  // 0.5 -> "0.5", 3.0 -> "3"
  String _ch(double ch) => ch == ch.truncate() ? '${ch.toInt()}' : '$ch';

  // Replace, don't edit: swap the course for a copy with one difference.
  void _replace(Course old, Course updated) {
    setState(() {
      final i = _courses.indexWhere((c) => identical(c, old));
      _courses[i] = updated;
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (context) => const AddCourseDialog(),
    );
    if (course != null) {
      setState(() => _courses = [..._courses, course]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalCh = 0;
    double enrolledCh = 0;
    int enrolledCount = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
      if (c.enrolled) {
        enrolledCh = enrolledCh + c.creditHours;
        enrolledCount = enrolledCount + 1;
      }
    }

    final dayFilter = _dayFilter;
    final shown = dayFilter == null
        ? _courses
        : _courses.where((c) => c.day.contains(dayFilter)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCourse,
        icon: const Icon(Icons.add),
        label: const Text('Add course'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                      '${_courses.length} courses · ${_ch(totalCh)} credit hours'),
                  const SizedBox(height: 4),
                  Text(
                    'Enrolled: $enrolledCount · ${_ch(enrolledCh)} credit hours',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _dayFilter == null,
                  onSelected: (_) => setState(() => _dayFilter = null),
                ),
                for (final day in _days) ...[
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(day),
                    selected: _dayFilter == day,
                    onSelected: (_) => setState(() => _dayFilter = day),
                  ),
                ],
              ],
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
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    tooltip: 'Star',
                                    icon: Icon(course.starred
                                        ? Icons.star
                                        : Icons.star_border),
                                    color: course.starred
                                        ? Colors.amber.shade700
                                        : null,
                                    onPressed: () => _replace(
                                      course,
                                      course.copyWith(
                                          starred: !course.starred),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 88),
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
                              child: Icon(course.icon,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                            title: Text(course.code),
                            subtitle: Text(
                                '${course.name}\n'
                                '${course.day} · ${course.time} · ${course.venue}\n'
                                'Instructor: ${course.instructor ?? 'TBA'}'),
                            isThreeLine: true,
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${_ch(course.creditHours)} CH'),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => _replace(
                                        course,
                                        course.copyWith(
                                            starred: !course.starred),
                                      ),
                                      child: Icon(
                                        course.starred
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: course.starred
                                            ? Colors.amber.shade700
                                            : null,
                                      ),
                                    ),
                                    Checkbox(
                                      value: course.enrolled,
                                      visualDensity: VisualDensity.compact,
                                      onChanged: (v) => _replace(
                                        course,
                                        course.copyWith(enrolled: v ?? false),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${course.code} tapped')),
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
