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

  late List<Course> _courses;
  @override
  void initState(){
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(int index){
    setState(() {
      _courses[index] = _courses[index].copyWith(isFavourite: !_courses[index].isFavourite);
    });
  }

  void _toggleEnrolled(int index){
    setState(() {
      _courses[index] = _courses[index].copyWith(enrolled: !_courses[index].enrolled,);
    });
  }

  Future<void> _addCourse() async{
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh += c.creditHours;
    }
    final enrolledCh = _courses.where((c) => c.enrolled).fold<int>(0, (sum, c) => sum + c.creditHours);

    final displayedCourses = _favoritesOnly? _courses.where((c) => c.isFavourite).toList(): _courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
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
                '${_courses.length} courses • $totalCh credit hours\n' 'Enrolled: $enrolledCh CH',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                FilterChip(label: const Text('Favourites only'),
                selected: _favoritesOnly,
                onSelected: (bool selected){
                  setState(() {
                    _favoritesOnly = selected;
                  });
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
                      childAspectRatio: 1.2,
                    ),
                    itemCount: displayedCourses.length,
                    itemBuilder: (context, index) {
                      final course = displayedCourses[index];
                      return Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(course.icon, size: 40),
                                const SizedBox(height: 8),
                                Text(
                                  course.code,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                    itemCount: displayedCourses.length,
                    itemBuilder: (context, index) {
                      final course = displayedCourses[index];
                      final originalIndex = _courses.indexOf(course);
                      final dayShort = course.day.substring(0,3);
                      final instructorName = course.instructor ?? 'TBA';
                      final subtitleText = '$dayShort ${course.time} • ${course.venue} • $instructorName';
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            course.enrolled ? Icons.check_circle: course.icon,
                            color: course.enrolled ? Colors.green: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(course.code),
                        subtitle: Text(subtitleText),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavourite ? Icons.star : Icons.star_border,
                            color: course.isFavourite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(originalIndex),
                        ),
                        onTap: () => _toggleEnrolled(originalIndex),
                        onLongPress: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete course?'),
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
                              _courses.removeAt(originalIndex);
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}