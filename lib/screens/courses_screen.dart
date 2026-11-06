import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/clear_fav_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  double get enrolledCh => _courses
      .where((c) => c.enrolled)
      .fold<double>(0, (sum, c) => sum + c.creditHours);

  bool _isGrid = false;
  String _selectedDay = 'All';
  bool _favoritesOnly = false;

  late List<Course> _courses;

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  Future<void> _clearFavourites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (_) => const ClearFavouritesScreen()),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      for (var i = 0; i < _courses.length; i++) {
        if (_courses[i].isFavorite) {
          _courses[i] = _courses[i].copyWith(isFavorite: false);
        }
      }
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
        existingCodes: _courses.map((c) => c.code).whereType<String>().toList(),
      ),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  Future<void> _removeCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    setState(() => _courses.remove(course));
  }

  @override
  void initState() {
    super.initState();
    _courses = List.of(
      sampleCourses,
    ); //list.of make a copy of the sampleCourses list, so that we can modify it without affecting the original list.
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours.toInt();
    }

    const dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    final shown = _courses.where((course) {
      final matchesDay = _selectedDay == 'All' || course.day == _selectedDay;
      final matchesFavorite = !_favoritesOnly || course.isFavorite;

      return matchesDay && matchesFavorite;
    }).toList();

    shown.sort(
      (a, b) => (dayOrder[a.day] ?? 8).compareTo(dayOrder[b.day] ?? 8),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), //opens add gp dialog
            onPressed: _addCourse,
          ),
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid View',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ), //teach top button to flip memory
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          DropdownButton<String>(
            value: _selectedDay,
            items: ['All', ...dayOrder.keys]
                .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                .toList(),
            onChanged: (day) {
              if (day == null) return;
              setState(() => _selectedDay = day);
            },
          ),
          FilterChip(
            label: const Text('★ favourites only'),
            selected: _favoritesOnly,
            onSelected: (selected) {
              setState(() => _favoritesOnly = selected);
            },
          ),

          OutlinedButton(
            onPressed: _clearFavourites,
            child: const Text('Clear all favourites'),
          ),

          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No courses available'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
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
                                course.code ?? 'TBA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                course.name ?? 'TBA',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8), // ADD

                              Text(
                                // ADD: Hari dan masa.
                                '${course.day.substring(0, 3)} ${course.time}',
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                // ADD: Venue.
                                course.venue,
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                // ADD: Instructor, atau TBA jika tiada.
                                course.instructor ?? 'TBA',
                                textAlign: TextAlign.center,
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
                      //print('Building row $index');
                      final course = shown[index];
                      final sourceIndex = _courses.indexOf(course);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Icon(
                            course.enrolled ? Icons.check_circle : course.icon,
                            color: course.enrolled
                                ? Colors.green
                                : Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          '${course.code}',
                          style: TextStyle(
                            color: index.isOdd
                                ? Colors.black.withValues(alpha: 0.3)
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          '${course.day.substring(0, 3)} · ${course.time} · ${course.venue}\n · ${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        onTap: () async {
                          final removed = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailScreen(course: _courses[index]),
                            ),
                          );
                          if (removed == true) {
                            setState(() => _courses.removeAt(index));
                          }
                        },
                        onLongPress: () => _removeCourse(course),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(sourceIndex),
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
