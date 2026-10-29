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
  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static const Map<String, int> _dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  late List<Course> _courses;
  bool _isGrid = false;
  String? _selectedDay; // null = all days
  bool _favOnly = false; // "favourites only" chip

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  // ---------- helpers ----------

  // Day filter + favourites filter, then sorted by day and time.
  // Always built from _courses.
  List<Course> get _shown {
    final list = _courses
        .where((c) =>
            (_selectedDay == null || c.day == _selectedDay) &&
            (!_favOnly || c.isFavorite))
        .toList();
    list.sort((a, b) {
      final byDay = (_dayOrder[a.day] ?? 8).compareTo(_dayOrder[b.day] ?? 8);
      return byDay != 0 ? byDay : a.time.compareTo(b.time);
    });
    return list;
  }

  String _shortDay(Course c) =>
      c.day.length > 3 ? c.day.substring(0, 3) : c.day;

  String _startTime(Course c) => c.time.split(RegExp(r'[-–]')).first;

  // Example: "Mon 09:00 · LT A"
  String _info(Course c) => '${_shortDay(c)} ${_startTime(c)} · ${c.venue}';

  // The list on screen is filtered and sorted, so we look up the real
  // position in _courses instead of using the row's index.
  void _toggleFavorite(Course course) {
    final i = _courses.indexOf(course);
    if (i == -1) return;
    setState(() {
      _courses[i] = course.copyWith(isFavorite: !course.isFavorite);
    });
  }

  void _toggleEnrolled(Course course) {
    final i = _courses.indexOf(course);
    if (i == -1) return;
    setState(() {
      _courses[i] = course.copyWith(enrolled: !course.enrolled);
    });
  }

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return; // the user cancelled
    setState(() => _courses.add(course));
  }

  Future<void> _confirmRemove(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${course.code} from your courses?'),
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
    if (confirmed == true) {
      setState(() => _courses.remove(course));
    }
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _courses) {
      totalCh = totalCh + c.creditHours;
    }

    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    final shown = _shown;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
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
          // Summary card
          Card(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_courses.length} courses · $totalCh credit hours\n'
                'Enrolled: $enrolledCh CH',
              ),
            ),
          ),

          // Filter chips: favourites + days
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('★ Favourites only'),
                  selected: _favOnly,
                  onSelected: (v) => setState(() => _favOnly = v),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedDay == null,
                  onSelected: (_) => setState(() => _selectedDay = null),
                ),
                for (final d in _days)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(d.substring(0, 3)),
                      selected: _selectedDay == d,
                      onSelected: (_) => setState(() => _selectedDay = d),
                    ),
                  ),
              ],
            ),
          ),

          // List / grid / empty message
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Text(
                      _favOnly
                          ? 'No starred courses here yet'
                          : 'No classes! Alhamdulillah :)',
                    ),
                  )
                : _isGrid
                    ? _buildGrid(shown)
                    : _buildList(shown),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Course> shown) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final course = shown[index];
        return ListTile(
          isThreeLine: true,
          tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              course.enrolled ? Icons.check_circle : course.icon,
              color: course.enrolled
                  ? Colors.green
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text('${course.code} · ${course.creditHours} CH'),
          subtitle: Text(
            '${course.name}\n${_info(course)} · ${course.instructor ?? 'TBA'}',
          ),
          trailing: IconButton(
            icon: Icon(
              course.isFavorite ? Icons.star : Icons.star_border,
              color: course.isFavorite ? Colors.amber : null,
            ),
            onPressed: () => _toggleFavorite(course),
          ),
          onTap: () => _toggleEnrolled(course),
          onLongPress: () => _confirmRemove(course),
        );
      },
    );
  }

  Widget _buildGrid(List<Course> shown) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final course = shown[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _toggleEnrolled(course),
            onLongPress: () => _confirmRemove(course),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    course.enrolled ? Icons.check_circle : course.icon,
                    size: 32,
                    color: course.enrolled ? Colors.green : null,
                  ),
                  const SizedBox(height: 4),
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
                  Text(
                    _info(course),
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  IconButton(
                    icon: Icon(
                      course.isFavorite ? Icons.star : Icons.star_border,
                      color: course.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () => _toggleFavorite(course),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}