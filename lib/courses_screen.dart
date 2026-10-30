import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';   // ← NEW this step

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
@override
void initState() {
  super.initState();
  _courses = List.of(sampleCourses);   // our own copy, safe to change
}

void _toggleFavorite(int index) {
  setState(() {
    _courses[index] =
        _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
  });
}

 void _toggleEnrolled(int index) {   // ← NEW: same shape as the star
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {        // ← CHANGED: was _openAddDialog
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(),
      ),
    );
    if (course == null) return;   // the user cancelled, so do nothing
    setState(() => _courses.add(course));
  }

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

String selectedDay = 'Monday';
  bool _isGrid = false; // ← NEW
  bool _favOnly = false;
  @override
  Widget build(BuildContext context) {
     int totalCh = 0; // ← NEW
    for (final c in _courses) {   // ← CHANGED: was sampleCourses
      totalCh = totalCh + c.creditHours; // ← NEW
    } // ← NEW

    final enrolledCh = _courses
    .where((c) => c.enrolled)
    .fold<int>(0, (sum, c) => sum + c.creditHours);

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
          IconButton(                        // ← NEW: opens the Add popup
            icon: const Icon(Icons.add),
            onPressed: _addCourse,         // ← CHANGED: was _openAddDialog
          ),
           IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list), // ← CHANGED
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid), // ← CHANGED
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
      body: Column( // ← CHANGED
        children: [
          Card( // ← NEW
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                   '${_courses.length} courses · $totalCh credit hours\n'
                  'Enrolled: $enrolledCh CH',   // ← NEW: the second line
            ),
          ),
        ), 

          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              label: const Text('★ favourites only'),
              selected: _favOnly,
              onSelected: (v) => setState(() => _favOnly = v),
            ),
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
                              Text(
                                course.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme.primaryContainer,
                           child: Icon(
                            course.enrolled            // ← CHANGED: was course.icon
                                ? Icons.check_circle
                                : course.icon,
                            color: course.enrolled     // ← CHANGED
                                ? Colors.green
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
              
                          title: Text(course.code),

                           subtitle: Text(
                          '${course.name} · ${course.day}',   // ← CHANGED: day moved in here
                        ),
                        trailing: IconButton(                 // ← CHANGED: was Text(course.day)
                          icon: Icon(
                            course.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(_courses.indexOf(course)),
                        ),

                        onTap: () => _toggleEnrolled(_courses.indexOf(course)),
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
