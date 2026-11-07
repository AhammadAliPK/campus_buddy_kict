import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';

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

  Future<void> _deleteCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _courses.remove(course);
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );

    if (!mounted || course == null) return;

    setState(() {
      _courses.add(course);
    });
  }

  Future<void> _openCourseDetails(Course course) async {
    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );

    if (!mounted) return;

    if (removed == true) {
      setState(() {
        _courses.remove(course);
      });
    }
  }

  bool _isGrid = false;
  String _selectedDay = 'All';
  bool _favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    final dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    final filteredCourses = _courses.where((course) {
      // First filter: selected day
      final matchesDay = _selectedDay == 'All' || course.day == _selectedDay;

      // Second filter: favourites only
      final matchesFavorite = !_favoritesOnly || course.isFavorite;

      // Both conditions must be satisfied
      return matchesDay && matchesFavorite;
    }).toList();

    // Sort the filtered courses by day
    filteredCourses.sort((a, b) {
      return (dayOrder[a.day] ?? 8).compareTo(dayOrder[b.day] ?? 8);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addCourse),
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        children: [
          // to display total courses and credit hours
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedDay,
              decoration: const InputDecoration(
                labelText: 'Filter by day',
                border: OutlineInputBorder(),
              ),
              items:
                  [
                    'All',
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                  ].map((day) {
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
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ Favourites only'),
                selected: _favoritesOnly,
                onSelected: (selected) {
                  setState(() {
                    _favoritesOnly = selected;
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    // itemCount: sortedCourses.length,
                    itemCount:
                        filteredCourses.length, //to filter courses based on day
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];

                      return Card(
                        child: InkWell(
                          onTap: () => _openCourseDetails(course),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(course.icon, size: 40),
                                const SizedBox(height: 8),
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
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];

                      return ListTile(
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.name),
                            Text(
                              '${course.day.substring(0, 3)} ${course.time} · ${course.venue}',
                            ),
                            Text('${course.creditHours} Credit Hours'),
                            Text('Instructor: ${course.instructor ?? 'TBA'}'),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: course.enrolled ? 'Unenroll' : 'Enroll',
                              icon: Icon(
                                course.enrolled
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: course.enrolled ? Colors.green : null,
                              ),
                              onPressed: () =>
                                  _toggleEnrolled(_courses.indexOf(course)),
                            ),
                            IconButton(
                              tooltip: 'Favourite',
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () =>
                                  _toggleFavorite(_courses.indexOf(course)),
                            ),
                          ],
                        ),

                        // onTap: () => _toggleEnrolled(_courses.indexOf(course)),
                        onTap: () => _openCourseDetails(course),

                        //Long press action to delete a course
                        onLongPress: () => _deleteCourse(course),

                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
