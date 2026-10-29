import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';   // ← NEW this step

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
    // Create a modifiable copy of the sample data
    _courses = List.of(sampleCourses);     
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index) { // NEW: same shape as the star
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async { // CHANGED: was _openAddDialog
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => const AddCourseDialog(),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }


  bool _isGrid = false; // ← NEW
  String _selectedDay = 'Monday'; // ← NEW

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']; // ← NEW

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in _courses) { // ← NEW
      totalCh = totalCh + c.creditHours; // ← NEW
    } // ← NEW

    final enrolledCh = _courses // NEW
      .where((c) => c.enrolled)
      .fold<int>(0, (sum, c) => sum + c.creditHours);

    final shown = sampleCourses.where((c) => c.day == _selectedDay).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse, // ← NEW
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list), // ← CHANGED
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid), // ← CHANGED
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
                '${_courses.length} courses · $totalCh credit hours\n' // ← UPDATED
                'Enrolled: $enrolledCh CH'),   // ← NEW: the second line
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: _days.map((day) {
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
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          
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
            : shown.isEmpty
            ? const Center(
                child: Text(
                  'No classes! Alhamdulillah :)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )  
            : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      course.enrolled // CHANGED: was course.icon
                      ? Icons.check_circle
                      : course.icon,
                      color: course.enrolled // CHANGED
                      ? Colors.green
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(course.code),
                  subtitle: Text(
                    '${course.name} · ${course.day}', // CHANGED: day moved in here
                  ),
                  trailing: IconButton( // CHANGED: was Text(course.day)
                    icon: Icon(
                      course.isFavorite ? Icons.star : Icons.star_border,
                      color: course.isFavorite ? Colors.amber : null,
                    ),
                  onPressed: () => _toggleFavorite(index),
                  ),
                  onTap: () => _toggleEnrolled(index),   // ← CHANGED
                  tileColor: index.isOdd // ← NEW
                  ? Colors.black.withValues(alpha: 0.03)
                  : null,
                );
              },
            ),
          )
        ]    
      )  
    );
  }
}