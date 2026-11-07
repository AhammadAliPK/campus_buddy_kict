import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const _days = [
    'All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'
  ];

  late List<Course> _courses;
  bool _isGrid = false;
  String _day = 'All';

  @override
  void initState() {
    super.initState();
    _courses = List.of(courses); // our own copy, safe to change
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

  @override
  Widget build(BuildContext context) {
    var totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    // from _courses, where day matches, make a list
    final shown = _day == 'All'
        ? _courses
        : _courses.where((c) => c.day == _day).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add a course',
            onPressed: _addCourse,
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          // summary card: totals over every course, not just the filtered ones
          Card(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ListTile(
              leading: const Icon(Icons.school),
              title: Text(
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
              ),
            ),
          ),
          // chip row: a sideways list
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: _day == day,
                    onSelected: (_) => setState(() => _day = day),
                  ),
                );
              },
            ),
          ),
          // a ListView inside a Column needs Expanded
          Expanded(child: _isGrid ? _buildGrid(shown) : _buildList(shown)),
        ],
      ),
    );
  }

  Widget _buildList(List<Course> shown) {
    return ListView.separated(
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final course = shown[index];
        // shown may be filtered, so find the course's place in _courses
        final i = _courses.indexOf(course);
        return ListTile(
          leading: Icon(
            course.enrolled ? Icons.check_circle : course.icon,
            color: course.enrolled ? Colors.green : null,
          ),
          title: Text(course.code), // the main line
          subtitle: Text('${course.name} · ${course.day}'),
          trailing: IconButton(
            icon: Icon(
              course.isFavorite ? Icons.star : Icons.star_border,
              color: course.isFavorite ? Colors.amber : null,
            ),
            onPressed: () => _toggleFavorite(i),
          ),
          onTap: () async {
            final removed = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => CourseDetailScreen(course: _courses[i]),
              ),
            );
            if (removed == true) {
              // remove the course itself, not the old position
              setState(() => _courses.remove(course));
            }
          },
        );
      },
      separatorBuilder: (_, _) => const Divider(), // thin line between rows
    );
  }

  Widget _buildGrid(List<Course> shown) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        mainAxisSpacing: 8, // vertical gap between cards
        crossAxisSpacing: 8, // horizontal gap between cards
        childAspectRatio: 1.2,
      ),
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final course = shown[index];
        return Card(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(course.icon, size: 40),
                const SizedBox(height: 8),
                Text(course.code),
                Text(course.day),
              ],
            ),
          ),
        );
      },
    );
  }
}
