
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  late List<Course> _courses;

  String selectedDay = 'Monday';
  bool _isGrid = false;
  bool _favOnly = false;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  // Toggle favourite
  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  // Toggle enrolled status
  void _toggleEnrolled(int index) {
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
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );

    if (course == null) return;

    setState(() => _courses.add(course));
  }

  // Remove course confirmation
  Future<void> _confirmRemove(Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code} from your courses?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (ok == true) {
      setState(() => _courses.remove(course));
    }
  }

  // Open course detail page
  Future<void> _openCourseDetail(Course course) async {
    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );

    if (removed == true) {
      setState(() => _courses.remove(course));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total credit hours
    int totalCh = 0;

    for (final c in _courses) {
      totalCh += c.creditHours;
    }

    // Calculate enrolled credit hours
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    // Sort courses by day
    final dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    final courses = [..._courses];

    courses.sort(
      (a, b) => (dayOrder[a.day] ?? 99)
          .compareTo(dayOrder[b.day] ?? 99),
    );

    // Filter courses
    final shown = courses
        .where((c) => c.day == selectedDay)
        .where((c) => !_favOnly || c.isFavorite)
        .toList();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Courses'),
          actions: [
            // Add course button
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add course',
              onPressed: _addCourse,
            ),

            // Grid/List toggle
            IconButton(
              icon: _isGrid
                  ? const Icon(Icons.grid_on)
                  : const Icon(Icons.list),
              tooltip: 'Grid view',
              onPressed: () {
                setState(() => _isGrid = !_isGrid);
              },
            ),
          ],

          bottom: TabBar(
            isScrollable: true,
            onTap: (index) {
              setState(() {
                selectedDay = days[index];
              });
            },
            tabs: const [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
            ],
          ),
        ),

        body: Column(
          children: [
            // Course summary card
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

            // Favourite filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilterChip(
                  label: const Text('★ Favourites'),
                  selected: _favOnly,
                  onSelected: (v) {
                    setState(() => _favOnly = v);
                  },
                ),
              ),
            ),

            // Course list or grid
            Expanded(
              child: shown.isEmpty
                  ? const Center(
                      child: Text('No classes! Alhamdulillah :)'),
                    )
                  : _isGrid
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
                              child: InkWell(
                                onTap: () => _openCourseDetail(course),
                                onLongPress: () => _confirmRemove(course),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        course.enrolled
                                            ? Icons.check_circle
                                            : course.icon,
                                        size: 40,
                                        color: course.enrolled
                                            ? Colors.green
                                            : null,
                                      ),
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
                                      IconButton(
                                        icon: Icon(
                                          course.isFavorite
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: course.isFavorite
                                              ? Colors.amber
                                              : null,
                                        ),
                                        onPressed: () => _toggleFavorite(
                                          _courses.indexOf(course),
                                        ),
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
                          itemCount: shown.length,
                          itemBuilder: (context, index) {
                            final course = shown[index];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme.primaryContainer,
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

                              title: Text(course.code),

                              subtitle: Text(
                                '${course.name} · ${course.day}',
                              ),

                              // Favourite button
                              trailing: IconButton(
                                icon: Icon(
                                  course.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: course.isFavorite
                                      ? Colors.amber
                                      : null,
                                ),
                                onPressed: () => _toggleFavorite(
                                  _courses.indexOf(course),
                                ),
                              ),

                              // Open detail page
                              onTap: () => _openCourseDetail(course),

                              // Remove confirmation
                              onLongPress: () => _confirmRemove(course),

                              tileColor: index.isOdd
                                  ? Colors.black.withValues(alpha: 0.03)
                                  : null,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
