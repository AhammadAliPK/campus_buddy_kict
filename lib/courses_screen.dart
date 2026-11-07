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
  final List<Course> _courses = List.of(sampleCourses)..sort(_byDayThenTime);

  static int _byDayThenTime(Course a, Course b) {
    final byDay = weekDays
        .indexOf(a.day.split(' & ').first)
        .compareTo(weekDays.indexOf(b.day.split(' & ').first));
    return byDay != 0 ? byDay : a.time.compareTo(b.time);
  }

  void _toggleFavorite(Course course) {
    final index = _courses.indexOf(course);
    setState(
      () => _courses[index] = course.copyWith(favorite: !course.favorite),
    );
  }

  void _setEnrolled(Course course, bool? value) {
    final index = _courses.indexOf(course);
    setState(() => _courses[index] = course.copyWith(enrolled: value ?? false));
  }

  Future<void> _addCourse() async {
    final newCourse = await showDialog<Course>(
      context: context,
      builder: (context) => const AddCourseDialog(),
    );
    if (newCourse == null) return;
    setState(() {
      _courses.add(newCourse);
      _courses.sort(_byDayThenTime);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${newCourse.code} added')));
  }

  @override
  Widget build(BuildContext context) {
    num totalCh = 0;
    num enrolledCh = 0;
    int enrolledCount = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
      if (c.enrolled) {
        enrolledCh = enrolledCh + c.creditHours;
        enrolledCount++;
      }
    }
    final shown = _courses.where((c) => c.day.contains('Tuesday')).toList();

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
                  Text('${_courses.length} courses · $totalCh credit hours'),
                  Text(
                    'Enrolled: $enrolledCount courses · $enrolledCh credit hours',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                              IconButton(
                                icon: Icon(
                                  course.favorite
                                      ? Icons.star
                                      : Icons.star_border,
                                ),
                                color: Colors.amber,
                                onPressed: () => _toggleFavorite(course),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 88),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      final shortDay = course.day
                          .split(' & ')
                          .map((d) => d.substring(0, 3))
                          .join('/');
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course.icon,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.creditHours} CH\n'
                          '$shortDay ${course.time} · ${course.venue}\n'
                          '${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                course.favorite
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                              color: Colors.amber,
                              tooltip: 'Favourite',
                              onPressed: () => _toggleFavorite(course),
                            ),
                            Checkbox(
                              value: course.enrolled,
                              onChanged: (v) => _setEnrolled(course, v),
                            ),
                          ],
                        ),
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
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
