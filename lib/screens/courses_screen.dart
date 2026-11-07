import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/confirmation_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _favoritesOnly = false;
  late List<Course> _courses;

  /*void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }*/

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  Future<void> _clearAllFavorites() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ConfirmationScreen()),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _courses = _courses.map((course) {
          return course.copyWith(isFavorite: false);
        }).toList();

        _favoritesOnly = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All favourites have been cleared!')),
      );
    }
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );
    if (course == null) return;
    setState(() => _courses.add(course));
  }

  Future<void> _removeCourse(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove course?'),
        content: const Text('Are you sure you want to remove this course?'),
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
      setState(() {
        _courses.removeAt(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  bool _isGrid = false;
  @override
  Widget build(BuildContext context) {
    int totalCh = 0;

    for (final c in _courses) {
      totalCh += c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    //final shown = _courses.toList();
    //final shown = sampleCourses.where((c) => c.day == 'Monday').toList();

    final shown = _courses.where((course) {
      if (_favoritesOnly && !course.isFavorite) {
        return false;
      }

      return true;
    }).toList();
    shown.sort((a, b) => dayOrder[a.day]!.compareTo(dayOrder[b.day]!));
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All Favourites',
            onPressed: _clearAllFavorites,
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: _addCourse),
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
                '${_courses.length} courses · $totalCh credit hours\n Enrolled: $enrolledCh CH',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ favourites only'),
                  selected: _favoritesOnly,
                  onSelected: (value) {
                    setState(() {
                      _favoritesOnly = value;
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      final actualIndex = _courses.indexOf(course);

                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
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
                        subtitle: Text(
                          '${course.name} · ${course.creditHours} CH\n'
                          '${course.day} ${course.time.split('–')[0]} · ${course.venue}\n'
                          '${course.instructor ?? 'TBA'}',
                        ),

                        onTap: () async {
                          final result = await Navigator.push<Object?>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailScreen(course: course),
                            ),
                          );

                          if (!mounted) return;

                          if (result is Course) {
                            setState(() {
                              final index = _courses.indexOf(course);

                              if (index != -1) {
                                _courses[index] = result;
                              }
                            });
                          } else if (result == true) {
                            setState(() {
                              _courses.remove(course);
                            });
                          }
                        },

                        onLongPress: () => _removeCourse(actualIndex),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(actualIndex),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
