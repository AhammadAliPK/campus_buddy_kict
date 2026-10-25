import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';  // brings in sampleCourses(actual data) from data/courses.dart

class CoursesScreen extends StatefulWidget {           // a screen that doesn't remember anything (yet)
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false; // remembers which view is on. false = list (the start). _ = private to this file

  @override
  Widget build(BuildContext context) {       // build = "draw this screen"
    int totalCh = 0;                        //  "totalCh starts at 0. Walk through every course c in the list. Add its creditHours to totalCh." After the loop, totalCh holds the answer
    for (final c in sampleCourses) {        // go through every course, one by one, calling it c
      totalCh = totalCh + c.creditHours;    // add that course's credit hours to the counter
    }                                       // after the loop, totalCh = total credit hours
    final shown = [...sampleCourses];  // a copy of ALL courses (the ... copies every item)
    const dayOrder = {
      'Monday': 1, 'Tuesday': 2, 'Wednesday': 3,
      'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7,
    };
    shown.sort((a, b) => dayOrder[a.day]!.compareTo(dayOrder[b.day]!));
    // sort compares two courses a and b at a time:
    //   look up each one's day number, and the smaller number goes first.
    // ! = "I promise this day is in the map" (it is, if you spelled it right)
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
        ],
      ),
      body: Column(                           // stack things top to bottom
  children: [
    Card(                               // a white box with a shadow
      margin: const EdgeInsets.all(12), // space outside the card
      child: Padding(
        padding: const EdgeInsets.all(12), // space inside the card
        child: Text(
            '${sampleCourses.length} courses · $totalCh credit hours'),   // e.g. '6 courses · 18 credit hours'
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
      itemCount: shown.length, // one card per course
      itemBuilder: (context, index) {  // builds each card
        final course = shown[index];
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
     : shown.isEmpty
         ? const Center(child: Text('No classes! Alhamdulillah :)'))
         : ListView.builder(    // a scrolling list that builds rows on demand
        padding: const EdgeInsets.symmetric(vertical: 8), // space above and below the list
        itemCount: shown.length,        // how many rows = how many courses
        itemBuilder: (context, index) {         // runs once per row; index = 0, 1, 2...
          final course = shown[index];  // pick the course for this row
          return ListTile(                      // a standard row: left icon, texts, right text
            leading: CircleAvatar(              // round circle on the left
              backgroundColor: Theme.of(context).colorScheme.primaryContainer, // light teal
              child: Icon(course.icon,          // this course's icon inside the circle
                  color: Theme.of(context).colorScheme.onPrimaryContainer),    // dark teal
            ),
            title: Text(course.code),           // big text: 'CSCI 4311'
            subtitle: Text(
                '${course.name}\n'                         // line 1: the course name
                '${course.day.substring(0, 3)} · ${course.time}\n'  // line 2: 'Mon · 09:00–10:30'
                '${course.venue}'),
                // \n = new line. substring(0, 3) = first 3 letters: 'Monday' → 'Mon'
            isThreeLine: true,                             // give the row room for 2 subtitle lines
            trailing: Text(course.instructor ?? 'TBA'),    // ?? = "if missing, use 'TBA'"
            tileColor: index.isOdd
                ? Colors.black.withValues(alpha: 0.03)
                : null,            
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${course.code} tapped')),
            ),                                  // tap a row → grey message pops up at the bottom
          );
        },
      ),
    ),
  ],
),
    );
  }
}