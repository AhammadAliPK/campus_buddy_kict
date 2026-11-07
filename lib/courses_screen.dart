import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/course_detail_screen.dart';
import 'package:campus_buddy_kict/confirm_screen.dart';

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
  String? _selectedDay;
  bool _favOnly = false;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  // ---------- helpers ----------

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

  String _info(Course c) => '${_shortDay(c)} ${_startTime(c)} · ${c.venue}';

  void _toggleFavorite(Course course) {
    final i = _courses.indexOf(course);
    if (i == -1) return;
    setState(() {
      _courses[i] = course.copyWith(isFavorite: !course.isFavorite);
    });
  }

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

  Future<void> _openDetail(Course course) async {
    final result = await Navigator.push<CourseDetailResult>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );
    if (result == null || !mounted) return;

    final i = _courses.indexOf(course);
    if (i == -1) return;
    setState(() {
      if (result.removed) {
        _courses.removeAt(i);
      } else {
        _courses[i] = result.course;
      }
    });
  }

  // Clearing favourites works here because the course list lives in this screen.
  Future<void> _clearFavourites() async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          message: 'Clear all favourite courses?',
        ),
      ),
    );
    if (yes != true || !mounted) return;
    setState(() {
      for (var i = 0; i < _courses.length; i++) {
        if (_courses[i].isFavorite) {
          _courses[i] = _courses[i].copyWith(isFavorite: false);
        }
      }
    });
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
            icon: const Icon(Icons.star_border),
            tooltip: 'Clear all favourites',
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
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
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
          onTap: () => _openDetail(course),
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
            onTap: () => _openDetail(course),
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