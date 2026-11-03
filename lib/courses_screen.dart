import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/course.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const _days = ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  late List<Course> _courses; // our own editable copy
  bool _isGrid = false;
  bool _favOnly = false;
  String _selectedDay = 'All';

  @override
  void initState() {
    super.initState();
    _courses = List.of(courses);
  }

  List<Course> get _visibleCourses => _courses
      .where((c) => _selectedDay == 'All' || c.days.contains(_selectedDay))
      .where((c) => !_favOnly || c.isFavorite)
      .toList();

  void _toggleFavorite(Course course) {
    final i = _courses.indexOf(course);
    setState(() => _courses[i] = course.copyWith(isFavorite: !course.isFavorite));
  }

  void _toggleEnrolled(Course course) {
    final i = _courses.indexOf(course);
    setState(() => _courses[i] = course.copyWith(enrolled: !course.enrolled));
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

  Future<void> _confirmRemove(Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove')),
        ],
      ),
    );
    if (ok == true) setState(() => _courses.remove(course));
  }

  Widget _starButton(Course course) => IconButton(
        icon: Icon(
          course.isFavorite ? Icons.star : Icons.star_border,
          color: course.isFavorite ? Colors.amber : null,
        ),
        onPressed: () => _toggleFavorite(course),
      );

  Widget _buildList(List<Course> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final course = items[index];
        return ListTile(
          isThreeLine: true,
          leading: Icon(
            course.enrolled ? Icons.check_circle : course.icon,
            color: course.enrolled ? Colors.green : null,
          ),
          title: Text('${course.code} · ${course.name}'),
          subtitle: Text(
            '${course.daysLabel} · ${course.time}\n${course.venue}\n${course.lecturer}',
          ),
          trailing: _starButton(course),
          onTap: () => _toggleEnrolled(course),
          onLongPress: () => _confirmRemove(course),
        );
      },
      separatorBuilder: (_, _) => const Divider(),
    );
  }

  Widget _buildGrid(List<Course> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final course = items[index];
        return Card(
          child: InkWell(
            onTap: () => _toggleEnrolled(course),
            onLongPress: () => _confirmRemove(course),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        course.enrolled ? Icons.check_circle : course.icon,
                        size: 32,
                        color: course.enrolled ? Colors.green : null,
                      ),
                      const SizedBox(height: 6),
                      Text(course.code,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(course.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('${course.daysLabel} · ${course.time}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12)),
                      Text(course.venue,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      Text(course.lecturer,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Positioned(top: 0, right: 0, child: _starButton(course)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleCourses;

    var totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: 'Add course',
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            tooltip: _isGrid ? 'Show as list' : 'Show as grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '${_courses.length} courses · $totalCh credit hours\n'
                  'Enrolled: $enrolledCh CH',
                ),
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
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (_) => setState(() => _selectedDay = day),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No classes to show'))
                : (_isGrid ? _buildGrid(items) : _buildList(items)),
          ),
        ],
      ),
    );
  }
}
