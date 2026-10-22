import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _grid = false;
  String? _day; // null = show all days

  List<Course> get _visible => _day == null
      ? courses
      : courses.where((c) => c.days.contains(_day)).toList();

  void _showCourse(Course course) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${course.code} · ${course.creditHours} credit hours · ${course.time}',
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
          leading: Icon(course.icon),
          title: Text(course.code),
          subtitle: Text(course.name),
          trailing: Text(course.daysLabel),
          onTap: () => _showCourse(course),
        );
      },
      separatorBuilder: (_, _) => const Divider(height: 1),
    );
  }

  Widget _buildGrid(List<Course> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.2,
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
                  Text(
                    course.code,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    course.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    course.daysLabel,
                    style: const TextStyle(color: Colors.black54),
                  ),
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
    final items = _visible;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: _grid ? 'Show as list' : 'Show as grid',
            icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _grid = !_grid),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _day == null,
                    onSelected: (_) => setState(() => _day = null),
                  ),
                ),
                for (final day in days)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(day),
                      selected: _day == day,
                      onSelected: (_) => setState(() => _day = day),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No classes on this day'))
                : (_grid ? _buildGrid(items) : _buildList(items)),
          ),
        ],
      ),
    );
  }
}
