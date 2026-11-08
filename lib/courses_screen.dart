import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {


  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = 
        _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
    });
  }

  void _toggleEnrolled (int index){
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (context) => const AddCourseDialog(),
    );
    if (course == null) return; 
    setState(() => _courses.add(course));
  }

  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }
  bool _isGrid = false;
  String _selectedDay = 'All';
  bool _showFavoritesOnly = false;

  final Map<String, int> _dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  @override
  Widget build(BuildContext context) {

    List<Course> displayedCourses = List.from(_courses);
    if (_selectedDay != 'All') {
      displayedCourses = displayedCourses
        .where((course) => course.day == _selectedDay)
        .toList();
    }

    if (_showFavoritesOnly){
      displayedCourses = displayedCourses
        .where((course) => course.isFavorite)
        .toList();
    }

    displayedCourses.sort((a, b) {
      final dayA = _dayOrder[a.day] ?? 99;
      final dayB = _dayOrder[b.day] ?? 99;
      return dayA.compareTo(dayB);
    });

    int totalCh=0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    final enrolledCh = _courses
    .where( (c) => c.enrolled)
    .fold<int> (0, (sum,c) => sum + c.creditHours);

    final List<Course> sortedCourses = List.from(sampleCourses);
    sortedCourses.sort((a, b) {
      final dayA = _dayOrder[a.day] ?? 99;
      final dayB = _dayOrder[b.day] ?? 99;
      return dayA.compareTo(dayB);
    });
    
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
            onPressed: () => setState( () => _isGrid = !_isGrid), // D. wires this up
          ),
        ],
      ),
      body: Column(
        children:[

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedDay,
                  items: ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                    .map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDay = value;
                      });
                    }
                  },
                ),
                const SizedBox(width: 12),
                FilterChip(
                  label: const Text('Favorites only'),
                  selected: _showFavoritesOnly,
                  onSelected: (selected) {
                    setState(() {
                      _showFavoritesOnly = selected;
                    });
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_courses.length} courses, $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH'),
                
            ),
          ),
          Expanded(
            child: _isGrid
              ?GridView.builder(
                padding: const EdgeInsets.all( 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(course.icon, size: 40),
                          const SizedBox(height: 8),
                          Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(course.name, textAlign: TextAlign.center, maxLines:1 , overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  );
                },
              )
              :ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return ListTile(
                    tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        course.enrolled
                        ? Icons.check_circle
                        : course.icon,
                        color: course.enrolled
                        ? Colors.green
                        :Theme.of( context).colorScheme.onPrimaryContainer,  
                    ),
                    ),
                    title: Text(course.code),
                    subtitle: Text('${course.name} · ${course.day}',),
                    trailing: IconButton(
                      icon: Icon(course.isFavorite ? Icons.star : Icons.star_border),
                      color: course.isFavorite ? Colors.amber: null,
                      onPressed: () => _toggleFavorite(index),  
                    ),
                    onTap: () => _toggleEnrolled(index),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}