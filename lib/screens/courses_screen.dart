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
    bool _isGrid = false; // ← NEW
    String _selectedDay = 'All'; 
  final List<String> _days = ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  bool _showFavoritesOnly = false; // <-- NEW

  late List<Course> _courses;
  @override
  void initState() {
  super.initState();
  _courses = List.of(sampleCourses); // our own copy, safe to change
  }

  void toggleFavorite(int index) {
    setState(() {
      // This replaces the old course with a new copy where isFavorite is flipped
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
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
    // 1. First, filter by day (Notice we use 'var' instead of 'final' now!)
    var shown = _selectedDay == 'All' 
        ? _courses
        : _courses.where((c) => c.days.contains(_selectedDay)).toList();

    // 2. Then, filter by favorites if the toggle is turned on
    if (_showFavoritesOnly) {
      shown = shown.where((c) => c.isFavorite).toList();
    }

    // 3. Calculate total credit hours for the items currently on screen
    int totalCh = 0;
    for (final c in shown) {
      totalCh = totalCh + c.creditHours;
    }

    // 4. Calculate total enrolled hours from the master list
    final enrolledCh = _courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);
    
return Scaffold(
  floatingActionButton: FloatingActionButton(
  onPressed: () async {
    // 'await' pauses this code until the dialog closes
    final newCourse = await showDialog<Course>(
      context: context,
      builder: (context) => AddCourseDialog(existingCodes: _courses.map((c) => c.code).toList()),
    );

    // If they pressed 'Add' (and didn't just hit Cancel), add it to the list!
    if (newCourse != null) {
      setState(() {
        _courses.add(newCourse);
      });
    }
  },
  child: const Icon(Icons.add),
),
appBar: AppBar(
title: const Text('My Courses'),
actions: [
IconButton(
icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list), // ← CHANGED
tooltip: 'Grid view',
onPressed: () => setState(() => _isGrid = !_isGrid), // ← CHANGED
),
],
),
body: Column( // ← CHANGED
children: [
Card( // ← NEW
margin: const EdgeInsets.all(12),
child: Padding(
padding: const EdgeInsets.all(12),
child: Text(
  '${shown.length} courses · $totalCh credit hours\n' // \n starts a new line
  'Enrolled: $enrolledCh CH', 
),
),
),
SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
      children: [
        // --- NEW: FAVORITES CHIP ---
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FilterChip(
            label: const Text('⭐ Favourites only'),
            selected: _showFavoritesOnly,
            onSelected: (bool selected) {
              setState(() {
                _showFavoritesOnly = selected;
              });
            },
          ),
        ),
        
        // --- EXISTING DAYS CHIPS ---
        ..._days.map((day) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(day),
              selected: _selectedDay == day,
              onSelected: (bool selected) {
                setState(() {
                  _selectedDay = day;
                });
              },
            ),
          );
        }),
      ],
    ),
    ),
Expanded(
child: shown.isEmpty // ← CHANGED
? const Center(child: Text('No classes! Alhamdulillah :)'))
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
tileColor: index.isOdd
? Colors.black.withValues(alpha: 0.03)
: null,
leading: CircleAvatar(
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  child: Icon(
    course.enrolled ? Icons.check_circle : course.icon, // Green tick if enrolled
    color: course.enrolled 
        ? Colors.green 
        : Theme.of(context).colorScheme.onPrimaryContainer,
  ),
),
title: Text(course.code),
subtitle: Text('${course.days.join(', ')} · ${course.time} · ${course.venue}'),
trailing: Row(
  mainAxisSize: MainAxisSize.min, // Keeps the row from taking up the whole tile
  children: [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('${course.creditHours} CH'),
        Text(course.instructor ?? 'TBA', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    ),
    // --- NEW STAR BUTTON ---
    IconButton(
      icon: Icon(
        course.isFavorite ? Icons.star : Icons.star_border,
        color: course.isFavorite ? Colors.amber : null,
      ),
      onPressed: () {
        // Find the actual index of this course in the main _courses list
        final realIndex = _courses.indexWhere((c) => c.code == course.code);
        toggleFavorite(realIndex);
      },
    ),
  ],
),
onTap: () async {
  // Navigator.push slides the new page on top and waits for it to pop back
  final removed = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => CourseDetailScreen(course: course),
    ),
  );

  // If the detail page popped back 'true' (Remove button was pressed)
  if (removed == true) {
    setState(() {
      _courses.remove(course); // Deletes the exact course cleanly
    });
  }
},

onLongPress: () async {
  // 1. Show the confirmation dialog and wait for a true/false answer
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Course'),
      content: Text('Are you sure you want to remove ${course.code}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Answers false
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true), // Answers true
          child: const Text('Remove', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  // 2. If the user tapped 'Remove', delete it from the list
  if (shouldDelete == true) {
    setState(() {
      _courses.remove(course);
    });
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