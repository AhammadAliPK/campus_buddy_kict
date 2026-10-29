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

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); 
  }
  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
    });
  }
  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(enrolled: !_courses[index].enrolled);
    });
  }
  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => const AddCourseDialog(),
    );
    
    if (course == null) return; // The user cancelled, so do nothing
    
    setState(() => _courses.add(course)); // NEW: adds to list and redraws screen
  }
  Widget build(BuildContext context) {
    // 1. Map days to numbers for sorting[cite: 9]
    final dayOrder = {'Monday': 1, 'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4, 'Friday': 5};
    
    // 2. Create a sorted copy of the courses
    final sortedCourses = sampleCourses.toList()..sort((a, b) {
      return (dayOrder[a.day] ?? 6).compareTo(dayOrder[b.day] ?? 6);
    });

    // 3. Count credit hours based on the new list
    int totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
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
                '${_courses.length} courses | $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH', // CHANGED: Added the second line
                textAlign: TextAlign.center, // Optional: keeps it centered nicely
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _courses.length, // Updated to use the sorted list
                    itemBuilder: (context, index) {
                      final course = _courses[index]; 
                      return Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(course.icon, size: 40),
                              const SizedBox(height: 8),
                              Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(course.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _courses.length, // Updated to use the sorted list
                    itemBuilder: (context, index) {
                      final course = _courses[index]; 
                      return ListTile(
                        // Make the whole row tappable
                        onTap: () => _toggleEnrolled(index), 
                        
                        tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                        
                        // Show a green tick when enrolled
                        leading: CircleAvatar(
                          backgroundColor: course.enrolled 
                              ? Colors.green.withOpacity(0.2) 
                              : Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            course.enrolled ? Icons.check_circle : course.icon, 
                            color: course.enrolled 
                                ? Colors.green 
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        
                        title: Text(
                          course.code, 
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${course.name} | ${course.day}'), 
                            Text('${course.creditHours} CH'),
                            Text(course.venue),
                            Text(course.instructor ?? 'TBA'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(course.isFavorite ? Icons.star : Icons.star_border),
                          color: course.isFavorite ? Colors.amber : null,
                          onPressed: () => _toggleFavorite(index),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}