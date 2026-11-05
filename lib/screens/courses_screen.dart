import 'package:campus_buddy_kict/screens/course_detail.dart';
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
  bool _isGrid = false;
  bool _showFavouritesOnly = false;

  late List<Course> _courses = List.of(sampleCourses);

  String _selectedDay = 'All';

  final List<String> _days = ['All', 'M-W', 'T-TH', 'FRI'];

  // Filter and sort courses
  List<Course> get _filteredCourses {
    final dayValues = {'M-W': 1, 'T-TH': 2, 'FRI': 5};

    final result = _courses.where((course) {
      final matchesDay = _selectedDay == 'All' || course.day == _selectedDay;

      final matchesFavourite = !_showFavouritesOnly || course.isFavourite;

      return matchesDay && matchesFavourite;
    }).toList();

    result.sort(
      (a, b) => (dayValues[a.day] ?? 8).compareTo(dayValues[b.day] ?? 8),
    );

    return result;
  }

  // Toggle favourite
  void _toggleFavorite(Course course) {
    final index = _courses.indexWhere((c) => c.code == course.code);

    if (index == -1) return;

    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavourite: !_courses[index].isFavourite,
      );
    });
  }

  // Toggle enrolled
  void _toggleEnrolled(Course course) {
    final index = _courses.indexWhere((c) => c.code == course.code);

    if (index == -1) return;

    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  // Add course
  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (context) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );

    if (!mounted || course == null) return;

    setState(() {
      _courses.add(course);
    });
  }

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filteredCourses;

    final totalCh = _courses.fold<int>(0, (sum, c) => sum + c.creditHours);

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            onPressed: _addCourse,
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.grid_on : Icons.list),
            tooltip: 'Change view',
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
          // Course summary
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

          // Day filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: _days.map((day) {
                return ChoiceChip(
                  label: Text(day),
                  selected: _selectedDay == day,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Favourites filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                label: const Text('Favourites only'),
                selected: _showFavouritesOnly,
                onSelected: (value) {
                  setState(() {
                    _showFavouritesOnly = value;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Course list or grid
          Expanded(
            child: courses.isEmpty
                ? const Center(child: Text('No courses found!'))
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return Card(
                        child: InkWell(
                          onTap: () => _toggleEnrolled(course),
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
                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Icon(
                                  course.isFavourite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: course.isFavourite
                                      ? Colors.amber
                                      : null,
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
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return ListTile(
                        leading: IconButton(
                          onPressed: () => _toggleEnrolled(course),
                          icon: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            child: Icon(
                              course.enrolled
                                  ? Icons.check_circle
                                  : course.icon,
                              color: course.enrolled
                                  ? Colors.green
                                  : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                            ),
                          ),
                        ),

                        title: Text(course.code),

                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,

                        subtitle: Text('${course.name} · ${course.day}'),

                        trailing: IconButton(
                          icon: Icon(
                            course.isFavourite ? Icons.star : Icons.star_border,
                            color: course.isFavourite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(course),
                        ),

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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
