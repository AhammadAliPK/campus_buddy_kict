import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // Our own copy, safe to change
  }

  void _toggleFavourite(int index) {
    setState(() {
     _courses[index] = 
     _courses[index].copyWith(isFavourite: !_courses[index].isFavourite,
      );
    });
  }

  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    num totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses · $totalCh CH'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
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
                '${_courses.length} courses  .  $totalCh credit hours',
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
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                course.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                      final course = _courses[index];
                      final dayAbbr = course.day.length >= 3
                          ? course.day.substring(0, 3)
                          : course.day;

                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
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
                        subtitle:
                            Text('${course.name} . ${course.day}'),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavourite
                                ? Icons.star
                                : Icons.star_border,
                            color: course.isFavourite
                                ? Colors.amber
                                : null,
                          ),
                        onPressed: () => _toggleFavourite (index),
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