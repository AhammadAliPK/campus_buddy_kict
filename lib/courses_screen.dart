import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';  // brings in sampleCourses(actual data) from data/courses.dart
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';  // so this file knows AddCourseDialog

class CoursesScreen extends StatefulWidget {           // a screen that doesn't remember anything (yet)
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false; // remembers which view is on. false = list (the start). _ = private to this file
  late List<Course> _courses;
  // the screen's OWN list of courses. late = "I promise to fill it before it's used"

  static const _dayOrder = {             // moved here from build (your Week 4 sort)
    'Monday': 1, 'Tuesday': 2, 'Wednesday': 3,
    'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7,
  };

  @override
  void initState() {                     // runs ONCE, when the screen is first created
    super.initState();
    _courses = List.of(sampleCourses);   // make an editable COPY of the frozen const list
    _courses.sort((a, b) => _dayOrder[a.day]!.compareTo(_dayOrder[b.day]!)); // sort it once
  }

void _toggleFavorite(int index) {
  setState(() {                           // data changes → redraw
    _courses[index] =                     // put back at the same position...
        _courses[index].copyWith(isFavorite: !_courses[index].isFavorite);
        // ...a copy of this course with the star flipped (! = opposite)
  });
}

  void _toggleEnrolled(int index) {               // same idea as the star
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,      // flip enrolled
      );
    });
  }

  Future<void> _addCourse() async {               // async = can pause and wait
    final course = await showDialog<Course>(      // open popup, WAIT for a Course (or null)
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes: _courses.map((c) => c.code).toList(), // list of every current code
      ),
    );
    if (course == null) return;                   // Cancel → do nothing
    setState(() {
      _courses.add(course);                       // add the new course to the list
      _courses.sort((a, b) => _dayOrder[a.day]!.compareTo(_dayOrder[b.day]!));
    });
  }

  @override
  Widget build(BuildContext context) {       // build = "draw this screen"
    int totalCh = 0;                        //  "totalCh starts at 0. Walk through every course c in the list. Add its creditHours to totalCh." After the loop, totalCh holds the answer
    for (final c in _courses) {        // go through every course, one by one, calling it c
      totalCh = totalCh + c.creditHours;    // add that course's credit hours to the counter
    }                                       // after the loop, totalCh = total credit hours
    final enrolledCh = _courses
        .where((c) => c.enrolled)                 // keep only enrolled courses
        .fold<int>(0, (sum, c) => sum + c.creditHours); // add their hours, starting at 0

    return Scaffold(                         // ready-made screen: top bar + body
      appBar: AppBar(
        title: const Text('My Courses'),      // title in the top bar
        actions: [                           // buttons on the right of the top bar
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list), // icon changes with the view
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
            // ! means "opposite": true becomes false, false becomes true
            // setState = "I changed something I remember, redraw the screen"
          ),
          IconButton(
            icon: const Icon(Icons.add),     // the + icon
            onPressed: _addCourse,       // no brackets = "call this LATER, when tapped"
          ),
        ],
      ),
      body: Column(                           // stack things top to bottom
  children: [
    Card(                               // a white box with a shadow
      margin: const EdgeInsets.all(12), // space outside the card
      child: Padding(
        padding: const EdgeInsets.all(12), // space inside the card
        child: Text(
            '${_courses.length} courses · $totalCh credit hours\n'  // \n = new line
            'Enrolled: $enrolledCh CH'),                            // second line
      ),
    ),
    Expanded(                                               // "list, take ALL the remaining height"
      child: _isGrid                        // grid mode on?
      ? GridView.builder(               // YES → show a grid
      padding: const EdgeInsets.all(8),
      gridDelegate: 
      const SliverGridDelegateWithFixedCrossAxisCount( // grid layout rules:
      crossAxisCount: 2,          // 2 cards per row
      mainAxisSpacing: 8,         // gap between rows
      crossAxisSpacing: 8,        // gap between columns
      ),
      itemCount: _courses.length, // one card per course
      itemBuilder: (context, index) {  // builds each card
        final course = _courses[index];
        return Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // centre vertically
              children: [
                Icon(course.icon, size: 40),  // big icon
                const SizedBox(height: 8),    // small gap
                Text(course.code,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)), // bold code
                Text(course.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,                       // one line only
                    overflow: TextOverflow.ellipsis),  // too long → '...'
              ],
            ),
          ),
        );
      },
    )
     : _courses.isEmpty
         ? const Center(child: Text('No classes! Alhamdulillah :)'))
         : ListView.builder(    // a scrolling list that builds rows on demand
        padding: const EdgeInsets.symmetric(vertical: 8), // space above and below the list
        itemCount: _courses.length,        // how many rows = how many courses
        itemBuilder: (context, index) {         // runs once per row; index = 0, 1, 2...
          final course = _courses[index];  // pick the course for this row
          return ListTile(                      // a standard row: left icon, texts, right text
            leading: CircleAvatar(              // round circle on the left
              backgroundColor: Theme.of(context).colorScheme.primaryContainer, // light teal
              child: Icon(
                course.enrolled ? Icons.check_circle : course.icon,  // enrolled → tick icon
                color: course.enrolled
                    ? Colors.green                                    // enrolled → green
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(course.code),           // big text: 'CSCI 4311'
            subtitle: Text(
                '${course.name}\n'                         // line 1: the course name
                '${course.day.substring(0, 3)} · ${course.time}\n'  // line 2: 'Mon · 09:00–10:30'
                '${course.venue} · ${course.instructor ?? 'TBA'}'),  // e.g. 'Lab 1 · TBA'
                // \n = new line. substring(0, 3) = first 3 letters: 'Monday' → 'Mon'
            isThreeLine: true,                             // give the row room for 2 subtitle lines
              trailing: IconButton(                 // the right side is now a tappable button
                icon: Icon(
                  course.isFavorite                 // is this course starred?
                      ? Icons.star                  //   yes → filled star
                      : Icons.star_border,          //   no  → outline only
                  color: course.isFavorite ? Colors.amber : null, // gold if starred
                ),
                onPressed: () => _toggleFavorite(index),  // tap → flip the star for THIS row
              ),
            tileColor: index.isOdd
                ? Colors.black.withValues(alpha: 0.03)
                : null,            
            onTap: () => _toggleEnrolled(index),  // tap row → enrol / un-enrol                                 // tap a row → grey message pops up at the bottom
          );
        },
      ),
    ),
  ],
),
    );
  }
}