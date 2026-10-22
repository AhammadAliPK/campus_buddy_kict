import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false; // ← NEW

  @override
  Widget build(BuildContext context) {
    int totalCh = 0; // ← NEW
    for (final c in sampleCourses) { // ← NEW
      totalCh = totalCh + c.creditHours; // ← NEW
    } // ← NEW

    final shown = sampleCourses.where((c) => c.day == 'Sunday').toList(); // ← NEW

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
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${sampleCourses.length} courses · $totalCh credit hours'), // ← UPDATED
            ),
          ),
          Expanded(
            child: _isGrid // ← CHANGED
            ? GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // two cards per row
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: sampleCourses.length,
                itemBuilder: (context, index) {
                  final course = sampleCourses[index];
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
            : shown.isEmpty
            ? const Center(
                child: Text(
                  'No classes! Alhamdulillah :)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )  
            : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: shown.length,
              itemBuilder: (context, index) {
                final course = shown[index];
                return ListTile(
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
                  tileColor: index.isOdd // ← NEW
                  ? Colors.black.withValues(alpha: 0.03)
                  : null,
                );
              },
            ),
          )
        ]    
      )  
    );
  }
}