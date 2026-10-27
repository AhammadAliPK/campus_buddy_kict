import 'package:campus_buddy_kict/course.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const _days = ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  bool _isGrid = false;
  String _selectedDay = 'All';

  List<Course> get _visibleCourses => _selectedDay == 'All'
      ? courses
      : courses.where((c) => c.days.contains(_selectedDay)).toList();

  void _showCourse(Course course) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${course.code} · ${course.creditHours} credit hours\n'
            '${course.daysLabel}, ${course.time}\n'
            '${course.venue}\n'
            '${course.lecturer}',
          ),
        ),
      );
  }

  Widget _buildList(List<Course> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final course = items[index];
        return ListTile(
          isThreeLine: true,
          leading: Icon(course.icon),
          title: Text('${course.code} · ${course.name}'),
          subtitle: Text(
            '${course.time}\n${course.venue}\n${course.lecturer}',
          ),
          trailing: Text(course.daysLabel),
          onTap: () => _showCourse(course),
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
            onTap: () => _showCourse(course),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(course.icon, size: 32),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleCourses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Show as list' : 'Show as grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
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
                ? const Center(child: Text('No classes on this day'))
                : (_isGrid ? _buildGrid(items) : _buildList(items)),
          ),
        ],
      ),
    );
  }
}
