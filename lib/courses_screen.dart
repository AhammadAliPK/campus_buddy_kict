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
      mainAxisSpacing: 8,         // gap between rowscrossAxisSpacing: 8,        // gap between columns
      ),
      itemCount: sampleCourses.length, // one card per course
      itemBuilder: (context, index) {  // builds each card
        final course = sampleCourses[index];
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
  : ListView.builder(                   // a scrolling list that builds rows on demand
        padding: const EdgeInsets.symmetric(vertical: 8), // space above and below the list
        itemCount: sampleCourses.length,        // how many rows = how many courses
        itemBuilder: (context, index) {         // runs once per row; index = 0, 1, 2...
          final course = sampleCourses[index];  // pick the course for this row
          return ListTile(                      // a standard row: left icon, texts, right text
            leading: CircleAvatar(              // round circle on the left
              backgroundColor: Theme.of(context).colorScheme.primaryContainer, // light teal
              child: Icon(course.icon,          // this course's icon inside the circle
                  color: Theme.of(context).colorScheme.onPrimaryContainer),    // dark teal
            ),
            title: Text(course.code),           // big text: 'CSCI 4311'
            subtitle: Text('${course.name} · ${course.creditHours} CH'),
            // small text. ${...} puts a value inside a string → 'Mobile App Dev · 3 CH'
            trailing: Text(course.day),         // text on the right: 'Monday'
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