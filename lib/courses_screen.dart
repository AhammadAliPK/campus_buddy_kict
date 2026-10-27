import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const _days = ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

  bool _isGrid = false;
  String _day = 'All';

  @override
  Widget build(BuildContext context) {
    // from courses, where day matches, make a list
    final shown = _day == 'All'
        ? courses
        : courses.where((c) => c.day == _day).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
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
        return ListTile(
          leading: Icon(course.icon), // left: icon
          title: Text(course.code), // the main line
          subtitle: Text(course.name), // smaller grey second line
          trailing: Text(course.day), // right: the day
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${course.code} tapped')),
          ),
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
