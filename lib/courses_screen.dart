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

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] =
      _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
    });
  }

  void _toggleEnrolled(int index){
    setState(() {
        _courses[index] = _courses[index].copyWith(
          enrolled: !_courses[index].enrolled,
        );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList())
    );
    if (course==null) return;
    setState(() => _courses.add(course));
  }

  void _confirmDelete(Course course) async {
    final confirmed = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _courses.removeWhere((c) => c.code == course.code);
      });
    }
  }

  bool _isGrid = false;
  String _selectedDay = 'All'; // State variable for day filtering
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

    // Smart filtering to handle multi-day strings and favorite filters
    final shown = _courses.where((c) {
      if (_favoritesOnly && !c.isFavorite) return false;

      if (_selectedDay == 'All') return c.day != '';
      
      final dayUpper = c.day.toUpperCase();
      
      switch (_selectedDay) {
        case 'Mon':
          return dayUpper.contains('M'); // Matches 'M-W'
        case 'Tue':
          return dayUpper.startsWith('T') || dayUpper.contains('TUE'); // Matches 'T-TH'
        case 'Wed':
          return dayUpper.contains('W'); // Matches 'M-W' and 'WED'
        case 'Thu':
          return dayUpper.contains('TH'); // Matches 'T-TH'
        case 'Fri':
          return dayUpper.contains('F'); // Matches 'FRI'
        default:
          return true;
      }
    }).toList();

    const days = ['All', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

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
          
          // Row of FilterChips for favorites and days
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('★'),
                    selected: _favoritesOnly,
                    onSelected: (selected) {
                      setState(() {
                        _favoritesOnly = selected;
                      });
                    },
                  ),
                ),
                // Day Filter Chips
                ...days.map((day) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(day),
                      selected: _selectedDay == day,
                      onSelected: (selected) {
                        setState(() {
                          _selectedDay = day;
                        });
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
                ? const Center(child: Text('No classes found! Alhamdulillah :)'))
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // two cards per row
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: shown.length,
                        itemBuilder: (context, index) {
                          final course = shown[index];
                          // ← NEW: Wrap Grid Card in GestureDetector to handle long-press deletion
                          return GestureDetector(
                            onLongPress: () => _confirmDelete(course),
                            child: Card(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(course.icon, size: 36),
                                      const SizedBox(height: 6),
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
                                      const SizedBox(height: 4),
                                      Text(
                                        '${course.day} · ${course.time}',
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.black54),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                              child: Icon(
                                course.enrolled
                                  ? Icons.check_circle
                                  : course.icon,
                                color: course.enrolled
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onPrimaryContainer),
                            ),
                            title: Text(course.code),
                            subtitle: Text(
                              '${course.name}\n${course.creditHours} CH - ${course.day} - ${course.time} - ${course.venue}\nInstructor: ${course.instructor ?? "TBA"}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                  ? Icons.star
                                  : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () => _toggleFavorite(index),
                            ),
                            onTap: () => _toggleEnrolled(index),
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