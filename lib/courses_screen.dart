import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;

  final Map<String, int> _dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  @override
  Widget build(BuildContext context) {
    int totalCh=0;
    for (final c in sampleCourses) {
      totalCh = totalCh + c.creditHours;
    }

    final List<Course> sortedCourses = List.from(sampleCourses);
    sortedCourses.sort((a, b) {
      final dayA = _dayOrder[a.day] ?? 99;
      final dayB = _dayOrder[b.day] ?? 99;
      return dayA.compareTo(dayB);
    });
    
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState( () => _isGrid = !_isGrid), // D. wires this up
            ),
          ],
        ),
        body: Column(
          children:[
            Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${sampleCourses.length} courses, $totalCh credit hours'),
              ),
            ),
            Expanded(
              child: _isGrid
                ?GridView.builder(
                  padding: const EdgeInsets.all( 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: sampleCourses.length,
                  itemBuilder: (context, index) {
                    final course = sampleCourses[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(course.icon, size: 40),
                            const SizedBox(height: 8),
                            Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(course.name, textAlign: TextAlign.center, maxLines:1 , overflow: TextOverflow.ellipsis),
                          ],
                            ),
                        ),
                      
                    );
                  },
                )
              
              
              
              :ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: sortedCourses.length,
                itemBuilder: (context, index) {
                  final course = sortedCourses[index];
                  return ListTile(
                    tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(course.icon,
                        color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    title: Text(course.code),
                    subtitle: Text('${course.name} · ${course.creditHours} CH'),
                    trailing: Text(course.day),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${course.code} tapped')),
                      ),
                  );
                },
              ),
            ),

          ]
          
            ),
          
        
    );
  }
}