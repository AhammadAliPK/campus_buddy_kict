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
  String _selectedDay = 'All';
  bool _favoritesOnly = false;

  final List<String> _days = [
    'All',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
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
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );

    if (course != null) {
      setState(() {
        _courses.add(course);
      });
    }
  }

  Future<void> _removeCourse(int index) async {
    final course = _courses[index];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove course?'),
        content: Text('Are you sure you want to remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    setState(() {
      _courses.remove(course);
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;

    for (final course in _courses) {
      totalCh += course.creditHours;
    }

    final enrolledCh = _courses
        .where((course) => course.enrolled)
        .fold<int>(0, (sum, course) => sum + course.creditHours);

    // Week 4 filter: show Monday courses.
    final shown = _courses.where((course) {
      final matchesDay = _selectedDay == 'All' || course.day == _selectedDay;

      final matchesFavorite = !_favoritesOnly || course.isFavorite;

      return matchesDay && matchesFavorite;
    }).toList();
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
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedDay,
                  decoration: const InputDecoration(
                    labelText: 'Filter by day',
                    border: OutlineInputBorder(),
                  ),
                  items: _days.map((day) {
                    return DropdownMenuItem(value: day, child: Text(day));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDay = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                FilterChip(
                  label: const Text('★ Favourites only'),
                  selected: _favoritesOnly,
                  onSelected: (selected) {
                    setState(() {
                      _favoritesOnly = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_courses.length} courses · $totalCh credit hours',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('Enrolled: $enrolledCh CH'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      final actualIndex = _courses.indexOf(course);

                      return Card(
                        child: InkWell(
                          onTap: () => _toggleEnrolled(actualIndex),
                          onLongPress: () => _removeCourse(actualIndex),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
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
                                const SizedBox(height: 8),
                                Text(
                                  course.code,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(course.name, textAlign: TextAlign.center),
                                const SizedBox(height: 6),
                                Text(
                                  '${course.day.substring(0, 3)} '
                                  '${course.time}',
                                  textAlign: TextAlign.center,
                                ),
                                Text(course.venue, textAlign: TextAlign.center),
                                Text(
                                  course.instructor ?? 'TBA',
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  tooltip: 'Favourite',
                                  onPressed: () => _toggleFavorite(actualIndex),
                                  icon: Icon(
                                    course.isFavorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: course.isFavorite
                                        ? Colors.amber
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      final actualIndex = _courses.indexOf(course);

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
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.day}\n'
                          '${course.time} · ${course.venue}\n'
                          'Instructor: ${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${course.creditHours} CH'),
                            IconButton(
                              tooltip: 'Favourite',
                              onPressed: () => _toggleFavorite(actualIndex),
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _toggleEnrolled(actualIndex),
                        onLongPress: () => _removeCourse(actualIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
