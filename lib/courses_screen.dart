import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
class CoursesScreen extends StatefulWidget {
const CoursesScreen({super.key});

@override
State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
    bool _isGrid = false; // ← NEW
    String _selectedDay = 'All'; 
  final List<String> _days = ['All','Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
@override
Widget build(BuildContext context) {
    final shown = _selectedDay == 'All' 
    ? sampleCourses 
    : sampleCourses.where((c) => c.days.contains(_selectedDay)).toList();
    int totalCh = 0; // ← NEW
    for (final c in shown) {
    totalCh = totalCh + c.creditHours;
    }
    
return Scaffold(
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
'${shown.length} courses · $totalCh credit hours'),
),
),
SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: _days.map((day) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(day),
              selected: _selectedDay == day,
              onSelected: (bool selected) {
                // This forces the screen to rebuild with the new day!
                setState(() {
                  _selectedDay = day;
                });
              },
            ),
          );
        }).toList(),
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
child: Icon(course.icon,
color: Theme.of(context).colorScheme.onPrimaryContainer),
),
title: Text(course.code),
subtitle: Text('${course.days.join(', ')} · ${course.time} · ${course.venue}'),
trailing: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Text('${course.creditHours} CH'),
    Text(course.instructor ?? 'TBA', style: const TextStyle(color: Colors.grey, fontSize: 12)), 
  ],
),
onTap: () => ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text('${course.code} tapped')),
),
);
},
),
),
],
),
); 
}
}