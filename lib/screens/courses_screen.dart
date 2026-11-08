import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';   // ← NEW

/// Day name -> weekday number, used to sort the timetable.
const Map<String, int> _dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
  'Tue-Thu': 2,
  'Mon-Wed': 1,
};

/// Day name -> short name, used in the row subtitle ('Mon 09:00 · LT A').
const Map<String, String> _dayShort = {
  'Monday': 'Mon',
  'Tuesday': 'Tue',
  'Wednesday': 'Wed',
  'Thursday': 'Thu',
  'Friday': 'Fri',
  'Saturday': 'Sat',
  'Sunday': 'Sun',
  'Tue-Thu': 'Tue/Thu',
  'Mon-Wed': 'Mon/Wed',
};

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false; // -- NEW
  String? _selectedDay; // null = show every day
  bool _favOnly = false;   // ← NEW: true = show starred courses only

  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
      _courses = List.of(sampleCourses);   
  
  }

  void _toggleFavorite(Course course) {     // ← was: int index
    final i = _courses.indexOf(course);     // ← NEW: find where this course is
    setState(() {
      _courses[i] =                         // ← index → i
          _courses[i].copyWith(isFavorite: !_courses[i].isFavorite);
    });
  }

  
  void _toggleEnrolled(Course course) {   // ← NEW: same shape as the star
    final i = _courses.indexOf(course);
    setState(() {
      _courses[i] = _courses[i].copyWith(enrolled: !_courses[i].enrolled);
    });
  }

  Future<void> _addCourse() async {        // ← CHANGED: was _openAddDialog
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(                       // ← CHANGED: no const now
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return;   // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  
  Future<void> _removeCourse(Course course) async {   // ← NEW
    final sure = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),   // No = false
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),    // Yes = true
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (sure == true) {
      setState(() => _courses.remove(course));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Every day that actually has a class, in timetable order.
    final days = _courses.map((c) => c.day).toSet().toList()
      ..sort((a, b) => (_dayOrder[a] ?? 99).compareTo(_dayOrder[b] ?? 99));

    // 1. keep only the chosen day (all when nothing is chosen)
    final shown = _courses
        .where((c) => _selectedDay == null || c.day == _selectedDay)
        .where((c) => !_favOnly || c.isFavorite)   // ← NEW: favourites filter
        .toList();

    // 3. sort by day, then by start time
    shown.sort((a, b) {
      final byDay = (_dayOrder[a.day] ?? 99).compareTo(_dayOrder[b.day] ?? 99);
      return byDay != 0 ? byDay : a.time.compareTo(b.time);
    });

    int totalCh = 0;
    for (final c in shown) {
      totalCh = totalCh + c.creditHours;
    }

    
  final enrolledCh = _courses              // ← NEW
      .where((c) => c.enrolled)
      .fold<int>(0, (sum, c) => sum + c.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(                        // ← NEW: opens the Add popup
            icon: const Icon(Icons.add),
            onPressed: _addCourse,         // ← CHANGED: was _openAddDialog
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
                '${shown.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',   // ← NEW: the second line
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final day in ['All', ...days])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(day),
                      selected:
                          (_selectedDay ?? 'All') == day,
                      onSelected: (_) => setState(
                          () => _selectedDay = day == 'All' ? null : day),
                    ),
                  ),
                  FilterChip(                                  // ← NEW
                  label: const Text('★ favourites only'),
                  selected: _favOnly,
                  onSelected: (v) => setState(() => _favOnly = v),
                ),
              ],
            ),
          ),
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
                          crossAxisCount: 2, // two cards per row
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
                                  Text(course.code,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    course.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_dayShort[course.day]} ${course.time}',
                                    style: const TextStyle(fontSize: 12),
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
                          final course = shown[index];
                          return ListTile(
                            tileColor: index.isOdd
                                ? Colors.black.withValues(alpha: 0.03)
                                : null,
                            leading: GestureDetector(           // ← NEW: tap the icon to enroll
                              onTap: () => _toggleEnrolled(course),
                              child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                course.enrolled            // ← CHANGED: was course.icon
                                    ? Icons.check_circle
                                    : course.icon,
                                color: course.enrolled     // ← CHANGED
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            ),
                            title: Text(course.code),
                            subtitle: Text(
                              '${course.name}\n'
                              '${_dayShort[course.day]} ${course.time} · '
                              '${course.venue} · ${course.instructor ?? 'TBA'}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite ? Colors.amber : null,
                              ),
                              onPressed: () => _toggleFavorite(course),
                            ),
                          onTap: () async {                        // ← CHANGED: opens the detail page
                            final removed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(course: course),
                              ),
                            );
                            if (removed == true) {
                              setState(() => _courses.remove(course));
                            }
                          },
                          onLongPress: () => _removeCourse(course),   // ← NEW
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
