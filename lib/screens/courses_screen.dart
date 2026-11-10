import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _day = 'All';
  bool _favOnly = false;
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  Future<void> _clearFavourites() async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(message: 'Clear all favourites?'),
      ),
    );
    if (yes != true) return; // back arrow pops null, treat as No
    setState(() {
      _courses = _courses.map((c) => c.copyWith(isFavourite: false)).toList();
    });
  }

  // detail page answers: true = removed, Course = edited, null = back (no change)
  Future<void> _openDetail(Course course) async {
    final result = await Navigator.push<Object>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
    );
    if (result == true) {
      setState(() => _courses.remove(course));
    } else if (result is Course) {
      setState(() => _courses[_courses.indexOf(course)] = result);
    }
  }

  void _toggleFavourite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavourite: !_courses[index].isFavourite,
      );
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) =>
          AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );
    if (course == null) return; // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

  Future<void> _removeCourse(Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code}?'),
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
    if (ok != true) return;
    setState(() => _courses.remove(course));
  }

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
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
    final base = _favOnly
        ? _courses.where((c) => c.isFavourite).toList()
        : _courses;
    final shown = _day == 'All'
        ? ([...base]..sort(
            (a, b) => _days.indexOf(a.days.first) - _days.indexOf(b.days.first),
          ))
        : base.where((c) => c.days.contains(_day)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addCourse),
          IconButton(
            icon: const Icon(Icons.star_border),
            tooltip: 'Clear favourites',
            onPressed: _clearFavourites,
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
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final d in ['All', ..._days])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(d.substring(0, 3)),
                      selected: _day == d,
                      onSelected: (_) => setState(() => _day = d),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('★ favourites only'),
                selected: _favOnly,
                onSelected: (on) => setState(() => _favOnly = on),
              ),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Text(
                      _favOnly
                          ? 'No starred courses'
                          : 'No classes! Alhamdulillah :)',
                    ),
                  )
                : _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 240,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: shown.length,
                    itemBuilder: (context, index) {
                      final course = shown[index];
                      final realIndex = _courses.indexOf(course);
                      return Card(
                        child: InkWell(
                          onTap: () => _openDetail(course),
                          onLongPress: () => _removeCourse(course),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  course.enrolled
                                      ? Icons.check_circle
                                      : course.icon,
                                  size: 28,
                                  color: course.enrolled ? Colors.green : null,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  course.code,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('${course.creditHours} CH'),
                                Text(course.time),
                                Text(course.venue),
                                Center(
                                  child: Text(
                                    course.instructor ?? 'TBA',
                                    textAlign: TextAlign.center,
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
                      final realIndex = _courses.indexOf(course);
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
                        isThreeLine: true,
                        subtitle: Text(
                          '${course.name} \n'
                          '${course.creditHours} CH · ${course.time} \n'
                          '${course.venue}\n'
                          '${course.instructor ?? 'TBA'}',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavourite ? Icons.star : Icons.star_border,
                            color: course.isFavourite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavourite(realIndex),
                        ),
                        onTap: () => _openDetail(course),
                        onLongPress: () => _removeCourse(course),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
