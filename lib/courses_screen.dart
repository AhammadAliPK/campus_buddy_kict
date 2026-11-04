import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart'; // ← NEW week 5
import 'package:campus_buddy_kict/add_course_dialog.dart'; // ← NEW this step


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

void _toggleFavorite(int index) {
 setState(() {
 _courses[index] =
 _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
 });
}

void _toggleEnrolled(int index) {
  setState(() {
    _courses[index] = _courses[index].copyWith(
      enrolled: !_courses[index].enrolled,
    );
  });
}

Future<void> _addCourse() async { // ← CHANGED: was _openAddDialog
 final course = await showDialog<Course>(
 context: context,
 builder: (_) => const AddCourseDialog(),
 );
 if (course == null) return; // the user cancelled, so do nothing
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
      .where((c) => c.day == 'Monday')
      .toList(); // ← NEW

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
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
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
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
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
 onPressed: () => _toggleFavorite(index),
 ),

          onTap: () => _toggleEnrolled(index),
        );
        },
      )
    ),
  ],
),
);
}
}
