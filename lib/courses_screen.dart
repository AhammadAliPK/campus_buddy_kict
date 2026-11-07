
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart'; // ← NEW this week

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favoritesOnly = false;
  late List<Course> _courses;
  String _selectedDay = 'All';

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  void _toggleFavorite(Course course) {
    final index = _courses.indexOf(course);
    
    setState(() {
    _courses[index] =
    _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
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
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );

    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _removeCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Course'),
        content: Text('Remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _courses.remove(course);
      });
    }
  }

  Widget build(BuildContext context) {
    int totalCh = 0;

    for (final c in _courses) {
      totalCh += c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    final shown = _courses.where((course) {
      final matchesDay =
          _selectedDay == 'All' || course.day == _selectedDay;

      final matchesFavorite =
          !_favoritesOnly || course.isFavorite;

      return matchesDay && matchesFavorite;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid
                ? const Icon(Icons.grid_on)
                : const Icon(Icons.list),
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
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                  .map((day) => FilterChip(
                        label: Text(day),
                        selected: _selectedDay == day,
                        onSelected: (_) {
                          setState(() {
                            _selectedDay = day;
                          });
                        },
                      ))
                  .toList(),
            ),
          ),

          FilterChip(
            label: const Text('★ favourites only'),
            selected: _favoritesOnly,
            onSelected: (selected) {
              setState(() {
                _favoritesOnly = selected;
              });
            },
          ),
       
Expanded(
  child: shown.isEmpty
      ? const Center(
          child: Text('No classes! Alhamdulillah :)'),
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
              itemCount: shown.length,
              itemBuilder: (context, index) {
                final course = shown[index];

                return ListTile(
                  onTap: () => _toggleEnrolled(_courses.indexOf(course)),
                  tileColor: index.isOdd
                      ? Colors.black.withValues(alpha: 0.03)
                      : null,
                  
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      course.enrolled
                          ? Icons.check_circle
                          : course.icon,
                      color: course.enrolled
                          ? Colors.green
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),

                  title: Text(course.code),

                  subtitle: Text(
                    '${course.name} · ${course.day}',
                  ),

                  trailing: IconButton(
                    icon: Icon(
                      course.isFavorite ? Icons.star : Icons.star_border,
                      color: course.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () => _toggleFavorite(course),
                  ),
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
