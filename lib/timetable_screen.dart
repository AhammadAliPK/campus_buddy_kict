import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/data/sample_courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool _showGrid = false;

  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  String? _selectedDay; //null means "All"

  List<Course> get _visibleCourses {
    final day = _selectedDay;

    if (day == null) return sampleCourses;

    return sampleCourses.where((course) => course.day == day).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
        actions: [
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
          leading: Icon(course.icon),
          title: Text(course.code),
          subtitle: Text(course.name),
          trailing: Text(course.day),
          onTap: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    '${course.code} · ${course.lecturer} · ${course.day}, ${course.time}',
                  ),
                ),
              );
          },
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
        childAspectRatio: 1.1,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      '${course.code} · ${course.lecturer} · ${course.day}, ${course.time}',
                    ),
                  ),
                );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    course.icon,
                    color: Theme.of(context).colorScheme.primary,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
