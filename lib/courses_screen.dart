
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _selectedDay = 'All days';
  bool _favoritesOnly = false;
  late List<Course> _courses;

  Future<void> _addCourse() async {
  final newCourse = await showDialog<Course>(
    context: context,
    builder: (context) => AddCourseDialog(
    existingCodes: _courses.map((course) => course.code).toList(),
),
  );

  if (newCourse != null) {
    setState(() {
      _courses.add(newCourse);
    });
  }
}

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  // Toggle favourite status
  void _toggleFavorite(int index) {
    setState(() {
      final course = _courses[index];
      _courses[index] = course.copyWith(
        isFavorite: !course.isFavorite,
      );
    });
  }

  // Toggle enrollment status
  void _toggleEnrolled(int index) {
    setState(() {
      final course = _courses[index];
      _courses[index] = course.copyWith(
        enrolled: !course.enrolled,
      );
    });
  }

  @override
  //#buildd
  Widget build(BuildContext context) {
    int totalCh = 0;
    int enrolledCh = 0;

    // Calculate total and enrolled credit hours
    for (final course in _courses) {
      totalCh += course.creditHours;

      if (course.enrolled) {
        enrolledCh += course.creditHours;
      }
    }

    List<Course> shown = _courses.where((course) {
      bool matchesDay =
          _selectedDay == 'All days' || course.day == _selectedDay;

      bool matchesFavorite =
          !_favoritesOnly || course.isFavorite;

      return matchesDay && matchesFavorite;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Course',
              onPressed: _addCourse,
  ),
],
      ),

      body: Column(
        children: [
          // Course summary
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    '${_courses.length} courses · $totalCh credit hours',
                  ),
                  const SizedBox(height: 4),
                  Text('Enrolled: $enrolledCh CH'),
                ],
              ),
            ),
          ),

          // Day filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: _selectedDay,
              decoration: const InputDecoration(
                labelText: 'Filter by day',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All days',
                  child: Text('All days'),
                ),
                DropdownMenuItem(
                  value: 'Monday',
                  child: Text('Monday'),
                ),
                DropdownMenuItem(
                  value: 'Tuesday',
                  child: Text('Tuesday'),
                ),
                 DropdownMenuItem(
                  value: 'Wednesday',
                  child: Text('Wednesday'),
                ),
                 DropdownMenuItem(
                  value: 'Thursday',
                  child: Text('Thursday'),
                ),
                 DropdownMenuItem(
                  value: 'Friday',
                  child: Text('Friday'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDay = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 8),

          FilterChip(
            label: const Text('★ favourites only'),
            selected: _favoritesOnly,
            onSelected: (selected) {
              setState(() {
                _favoritesOnly = selected;
              });
            },
          ),
          const SizedBox(height: 8),

          // Course list or grid
          Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text('yayayayy have a good day'),
                  )
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          final courseIndex = _courses.indexOf(course);

                          return Card(
                            child: InkWell(
                              onTap: () =>
                                  _toggleEnrolled(courseIndex),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      course.enrolled
                                          ? Icons.check_circle
                                          : course.icon,
                                      size: 40,
                                      color: course.enrolled
                                          ? Colors.green
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      course.code,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        course.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        course.isFavorite
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: course.isFavorite
                                            ? Colors.amber
                                            : null,
                                      ),
                                      tooltip: course.isFavorite
                                          ? 'Remove favourite'
                                          : 'Add favourite',
                                      onPressed: () =>
                                          _toggleFavorite(courseIndex),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          final courseIndex = _courses.indexOf(course);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: course.enrolled
                                  ? Colors.green
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              child: Icon(
                                course.enrolled
                                    ? Icons.check
                                    : course.icon,
                                color: course.enrolled
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                              ),
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
                                color: course.isFavorite
                                    ? Colors.amber
                                    : null,
                              ),
                              tooltip: course.isFavorite
                                  ? 'Remove favourite'
                                  : 'Add favourite',
                              onPressed: () =>
                                  _toggleFavorite(courseIndex),
                            ),
                            onTap: () =>
                                _toggleEnrolled(courseIndex),
                            onLongPress: () {
                              _confirmRemoveCourse(courseIndex);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
  Future<void> _confirmRemoveCourse(int index) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Course?'),
      content: Text(
        'Are you sure you want to remove ${_courses[index].code}?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Remove'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    setState(() {
      _courses.removeAt(index);
    });
  }
}
}
