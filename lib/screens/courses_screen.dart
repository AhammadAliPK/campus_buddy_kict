import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favourites_screen.dart';

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

  // State for the FilterChip
  bool _showFavoritesOnly = false; 

  // The confirmation dialog and removal
  Future<void> _removeCourse(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // pop with false
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true), // pop with true
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    // Only remove if the user explicitly tapped "Remove" (true)
    if (confirm == true) {
      setState(() {
        _courses.removeAt(index);
      });
    }
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

    final displayedCourses = _showFavoritesOnly 
        ? _courses.where((c) => c.isFavorite).toList() 
        : _courses;

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
          IconButton(
            icon: const Icon(Icons.star_border_outlined),
            tooltip: 'Clear all favourites',
            onPressed: () async {
              final confirm = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClearFavouritesScreen(),
                ),
              );

              if (confirm == true) {
                setState(() {
                  for (int i = 0; i < _courses.length; i++) {
                    if (_courses[i].isFavorite) {
                      _courses[i] = _courses[i].copyWith(isFavorite: false);
                    }
                  }
                });
              }
            },
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ Favourites only'),
                  selected: _showFavoritesOnly,
                  onSelected: (val) {
                    setState(() => _showFavoritesOnly = val);
                  },
                ),
              ],
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
                // Use the length of the filtered list
                itemCount: displayedCourses.length, 
                itemBuilder: (context, index) {
                  
                  // Grab the course from the filtered view
                  final course = displayedCourses[index]; 
                  
                  // Find the real index in the main list so toggles/deletes apply to the correct item
                  final actualIndex = _courses.indexOf(course); 

                  return ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailScreen(course: course), 
                        ),
                      );
                      if (result == true) {
                        setState(() => _courses.remove(course));
                      } else if (result is Course) {
                        setState(() {
                          _courses[actualIndex] = result; 
                        });
                      }
                    },
                  
                    onLongPress: () => _removeCourse(actualIndex), 
                    
                    tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
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
                    title: Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      onPressed: () => _toggleFavorite(actualIndex), // Use actualIndex
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