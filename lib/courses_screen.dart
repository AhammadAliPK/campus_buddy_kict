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
  late List<Course> _courses;
  bool _isGrid = false;
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(int index, List<Course> displayedList) {
    final originalIndex = _courses.indexOf(displayedList[index]);
    setState(() {
      _courses[originalIndex] = _courses[originalIndex].copyWith(
        isFavorite: !_courses[originalIndex].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index, List<Course> displayedList) {
    final originalIndex = _courses.indexOf(displayedList[index]);
    setState(() {
      _courses[originalIndex] = _courses[originalIndex].copyWith(
        enrolled: !_courses[originalIndex].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (BuildContext dialogContext) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code.toUpperCase()).toList(),
      ),
    );

    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _confirmDelete(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${course.code}?'),
        content: Text('Are you sure you want to remove ${course.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _courses.remove(course));
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    final displayedCourses = _favoritesOnly
        ? _courses.where((c) => c.isFavorite).toList()
        : _courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _addCourse,
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_courses.length} courses • $totalCh credit hours\nEnrolled: $enrolledCh CH',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  FilterChip(
                    label: const Text('★ Favorites'),
                    selected: _favoritesOnly,
                    onSelected: (val) => setState(() => _favoritesOnly = val),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: displayedCourses.isEmpty
                ? const Center(
                    child: Text(
                      'No courses to display',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.05,
                        ),
                    itemCount: displayedCourses.length,
                    itemBuilder: (context, index) {
                      final course = displayedCourses[index];
                      return InkWell(
                        onTap: () => _toggleEnrolled(index, displayedCourses),
                        onLongPress: () => _confirmDelete(course),
                        child: Card(
                          color: course.enrolled
                              ? Colors.teal.withValues(alpha: 0.08)
                              : null,
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        course.enrolled
                                            ? Icons.check_circle
                                            : course.icon,
                                        size: 32,
                                        color: course.enrolled
                                            ? Colors.green
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                      ),
                                      const SizedBox(height: 6),
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
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        '${course.creditHours} CH • ${course.day}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  iconSize: 20,
                                  icon: Icon(
                                    course.isFavorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: course.isFavorite
                                        ? Colors.amber
                                        : null,
                                  ),
                                  onPressed: () =>
                                      _toggleFavorite(index, displayedCourses),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: displayedCourses.length,
                    itemBuilder: (context, index) {
                      final course = displayedCourses[index];
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Icon(
                            course.enrolled ? Icons.check_circle : course.icon,
                            color: course.enrolled
                                ? Colors.green
                                : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          course.code,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${course.name} (${course.day})'),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () =>
                              _toggleFavorite(index, displayedCourses),
                        ),
                        onTap: () => _toggleEnrolled(index, displayedCourses),
                        onLongPress: () => _confirmDelete(course),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
