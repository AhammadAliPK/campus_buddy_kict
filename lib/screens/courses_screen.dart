import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favorites_screen.dart'; 

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _showFavoritesOnly = false;
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
    
    final dayMap = {'Monday': 1, 'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4, 'Friday': 5};
    _courses.sort((a, b) => (dayMap[a.day] ?? 6).compareTo(dayMap[b.day] ?? 6));
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

  Future<void> _removeCourse(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Remove this course from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _courses.removeAt(index));
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

    setState(() => _courses.add(course)); 
  }

  Future<void> _clearFavorites() async {
    final confirm = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const ClearFavoritesScreen()),
    );

    if (confirm == true) {
      setState(() {
        for (int i = 0; i < _courses.length; i++) {
          _courses[i] = _courses[i].copyWith(isFavorite: false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    Iterable<Course> displayCourses = _courses;
    
    if (_showFavoritesOnly) {
      displayCourses = displayCourses.where((c) => c.isFavorite);
    }
    
    final displayList = displayCourses.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Clear Favourites',
            onPressed: _clearFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_on),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                    '${_courses.length} courses • $totalCh credit hours\n'
                    'Enrolled: $enrolledCh CH'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: FilterChip(
              label: const Text('Favourites only'),
              selected: _showFavoritesOnly,
              onSelected: (val) => setState(() => _showFavoritesOnly = val),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final course = displayList[index];
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
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final course = displayList[index];
                      final originalIndex = _courses.indexOf(course);
                      
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
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
                            '${course.name}\n${course.day} ${course.time} ${course.venue}\nInstructor: ${course.instructor ?? 'TBA'}'),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(originalIndex),
                        ),
                        onTap: () async {
                          final result = await Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailScreen(course: _courses[originalIndex]),
                            ),
                          );

                          if (result == true) { 
                            setState(() => _courses.removeAt(originalIndex));
                          } else if (result is Course) { 
                            setState(() => _courses[originalIndex] = result);
                          }
                        },
                        onLongPress: () => _removeCourse(originalIndex), 
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}