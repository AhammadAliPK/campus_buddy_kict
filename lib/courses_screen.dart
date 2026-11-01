import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {

  bool _isGrid = false;
  late List<Course> _courses;

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] =
      _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
    });
  }
  
  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => const AddCourseDialog(),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid), // D. wires this up
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
                '${_courses.length} courses · $totalCh credit hours'),
            ),
          ),
          Expanded(
            child: _isGrid // ← CHANGED
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
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      print('Building row $index');
                      final course = _courses[index];
                      return ListTile(
                        tileColor: index.isOdd
                        ? Colors.black.withValues(alpha: 0.03)
                        : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(course.icon,
                            color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.day}',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite
                              ? Icons.star
                              : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                        onPressed: () => _toggleFavorite(index),
                        ),
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