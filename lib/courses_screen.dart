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
  
  
  bool _favoritesOnly = false;
  String _selectedDay = 'All';
  
  final List<String> _days = [
    'All',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(Course course) {
    final index = _courses.indexOf(course);
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(Course course) {
    final index = _courses.indexOf(course);
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  
  Future<void> _removeCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _courses.remove(course);
      });
    }
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (context) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );

    if (course == null) return;

    setState(() {
      _courses.add(course);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final shown = _courses.where((c) {
      final matchesFav = !_favoritesOnly || c.isFavorite;
      final matchesDay = _selectedDay == 'All' || c.day == _selectedDay;
      return matchesFav && matchesDay;
    }).toList();

    final Map<String, int> dayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7
    };
    shown.sort((a, b) => (dayMap[a.day] ?? 99).compareTo(dayMap[b.day] ?? 99));

    int totalCh = 0;
    for (final c in shown) {
      totalCh = totalCh + c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Course',
            onPressed: _addCourse,
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            tooltip: 'Toggle view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${shown.length} courses · $totalCh credit hours\nEnrolled: $enrolledCh CH',
              ),
            ),
          ),
          
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  avatar: Icon(
                    _favoritesOnly ? Icons.star : Icons.star_border,
                    size: 18,
                    color: _favoritesOnly ? Colors.amber : null,
                  ),
                  label: const Text('★ Favourites only'),
                  selected: _favoritesOnly,
                  onSelected: (bool selected) {
                    setState(() {
                      _favoritesOnly = selected;
                    });
                  },
                ),
                const SizedBox(width: 8),
                const Text('|', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                ..._days.map((day) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(day),
                      selected: _selectedDay == day,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            _selectedDay = day;
                          });
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            child: shown.isEmpty
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
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          return Card(
                            child: InkWell(
                              onTap: () => _toggleEnrolled(course),
                              onLongPress: () => _removeCourse(course),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      course.enrolled
                                          ? Icons.check_circle
                                          : course.icon,
                                      size: 40,
                                      color: course.enrolled ? Colors.green : null,
                                    ),
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
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(alpha: 0.03)
                                : null,
                            leading: CircleAvatar(
                              backgroundColor: course.enrolled
                                  ? Colors.green.shade100
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              child: Icon(
                                course.enrolled
                                    ? Icons.check_circle
                                    : course.icon,
                                color: course.enrolled
                                    ? Colors.green
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                              ),
                            ),
                            title: Text(course.code),
                            subtitle: Text(
                              '${course.day} ${course.time} · ${course.venue}\nInstructor: ${course.instructor ?? 'TBA'}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                              color: course.isFavorite ? Colors.amber : null,
                              onPressed: () => _toggleFavorite(course),
                            ),
                            onTap: () => _toggleEnrolled(course),
                            onLongPress: () => _removeCourse(course),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}