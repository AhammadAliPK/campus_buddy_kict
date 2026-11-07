import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart'; // ← NEW week 5
import 'package:campus_buddy_kict/add_course_dialog.dart'; // ← NEW this step
import 'package:campus_buddy_kict/screens/course_details_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favourites_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {

late List<Course> _courses;
@override
void initState() {
 super.initState();
 _courses = List.of(sampleCourses); // our own copy, safe to change
}

bool _isGrid = false; // ← NEW
bool _favoritesOnly = false;

void _toggleFavorite(Course course) {
  setState(() {
    final index = _courses.indexOf(course);
    if (index == -1) return;

    _courses[index] = course.copyWith(
      isFavorite: !course.isFavorite,
    );
  });
}

void _toggleEnrolled(Course course) {
  setState(() {
    final index = _courses.indexOf(course);
    if (index == -1) return;

    _courses[index] = course.copyWith(
      enrolled: !course.enrolled,
    );
  });
}

Future<void> _removeCourse(Course course) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove course?'),
      content: Text(
        'Are you sure you want to remove ${course.code}?',
      ),
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
      _courses.remove(course);
    });
  }
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



@override
Widget build(BuildContext context) {
  int totalCh = 0; // ← NEW
  for (final c in _courses) { // ← NEW
    totalCh = totalCh + c.creditHours; // ← NEW
  }
  final enrolledCh = _courses
    .where((c) => c.enrolled)
    .fold<int>(0, (sum, c) => sum + c.creditHours);

  final shown = _courses
    .where((c) => !_favoritesOnly || c.isFavorite)
    .toList();

  return Scaffold(
    appBar: AppBar(
      title: const Text('My Courses'),
      
actions: [
  IconButton(
  icon: const Icon(Icons.delete_outline),
  tooltip: 'Clear all favourites',
  onPressed: () async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClearFavouritesScreen(),
      ),
    );

    if (confirmed == true) {
      setState(() {
        _courses = _courses
            .map((course) => course.copyWith(isFavorite: false))
            .toList();
      });
    }
  },
),

  IconButton(
    icon: const Icon(Icons.add),
    tooltip: 'Add course',
    onPressed: _addCourse,
  ),
  IconButton(
    icon: _isGrid
        ? const Icon(Icons.grid_on)
        : const Icon(Icons.list),
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

        // Favourites filter
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
      child: shown.isEmpty
          ? const Center(
               child: Text('No classes! Alhamdulillah :)'),
             )
          
          : _isGrid // ← CHANGED
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
                    Text(course.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
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
          tileColor: index.isOdd // ← NEW
              ? Colors.black.withValues(alpha: 0.03)
              : null,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
 course.enrolled // ← CHANGED: was course.icon
 ? Icons.check_circle
 : course.icon,
 color: course.enrolled // ← CHANGED
 ? Colors.green
 : Theme.of(context).colorScheme.onPrimaryContainer,
 ),

          
          ),
          title: Text(course.code),
          subtitle: Text(
            '${course.name} · ${course.day}', // ← CHANGED: day moved in here
 ),
 trailing: IconButton( // ← CHANGED: was Text(course.day)
 icon: Icon(
 course.isFavorite
 ? Icons.star
 : Icons.star_border,
 color: course.isFavorite ? Colors.amber : null,
 ),
 onPressed: () => _toggleFavorite(course),
 ),

        onTap: () async {
  final result = await Navigator.push<dynamic>(
    context,
    MaterialPageRoute(
      builder: (_) => CourseDetailScreen(course: course),
    ),
  );

  if (!mounted) return;

  // If an edited Course object is returned
  if (result is Course) {
    setState(() {
      final index = _courses.indexOf(course);

      if (index != -1) {
        _courses[index] = result;
      }
    });
  }

  // If true is returned, remove the course
  else if (result == true) {
    setState(() {
      _courses.remove(course);
    });
  }
}, 
         onLongPress: () => _removeCourse(course), 
        );
        },
      )
    ),
  ],
),
);
}
}
