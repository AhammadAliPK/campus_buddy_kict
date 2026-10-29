import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/data/sample_courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool _showGrid = false;

  late List<Course> _courses;

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  String? _selectedDay; //null means "All"

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(Course course) {
    final i = _courses.indexWhere((c) => c.code == course.code);
    if (i == -1) return;
    setState(() {
      _courses[i] =
          _courses[i].copyWith(isFavorite: !_courses[i].isFavorite);
    });
  }

  void _toggleEnrolled(Course course) {
    final i = _courses.indexWhere((c) => c.code == course.code);
    if (i == -1) return;
    setState(() {
      _courses[i] =
          _courses[i].copyWith(enrolled: !_courses[i].enrolled);
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

  List<Course> get _visibleCourses {
    final day = _selectedDay;

    if (day == null) return _courses;

    return _courses.where((course) => course.day == day).toList();
  }

  @override
  Widget build(BuildContext context) {
    var totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            tooltip: _showGrid ? 'Show List' : 'Show Grid',
            icon: Icon(_showGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _showGrid = !_showGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${_courses.length} courses · $totalCh credit hours\n'
                  'Enrolled: $enrolledCh CH',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _days.length + 1,
              itemBuilder: (context, index) {
                final day = index == 0 ? 'All' : _days[index - 1];
                final selected = day == 'All'
                    ? _selectedDay == null
                    : _selectedDay == day;

                return ChoiceChip(
                  label: Text(day),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedDay = day == 'All' ? null : day;
                    });
                  },
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_visibleCourses.isEmpty) {
      return const Center(child: Text('No classes on this day'));
    }

    return _showGrid ? _buildGrid() : _buildList();
  }

  Widget _buildList() {
    final courses = _visibleCourses;

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return ListTile(
          leading: Icon(
            course.enrolled ? Icons.check_circle : course.icon,
            color: course.enrolled
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
          title: Text(course.code),
          subtitle: Text(
            '${course.name} · ${course.day}',
          ),
          trailing: IconButton(
            icon: Icon(
              course.isFavorite ? Icons.star : Icons.star_border,
              color: course.isFavorite ? Colors.amber : null,
            ),
            onPressed: () => _toggleFavorite(course),
          ),
          onTap: () => _toggleEnrolled(course),
        );
      },
    );
  }

  Widget _buildGrid() {
    final courses = _visibleCourses;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _toggleEnrolled(course),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        course.enrolled
                            ? Icons.check_circle
                            : course.icon,
                        color: course.enrolled
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                      const Spacer(),
                      IconButton(
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          course.isFavorite
                              ? Icons.star
                              : Icons.star_border,
                        ),
                        color:
                            course.isFavorite ? Colors.amber : null,
                        onPressed: () => _toggleFavorite(course),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.code,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(course.day),
                  Text(course.time),
                  Text('${course.creditHours} CH'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
