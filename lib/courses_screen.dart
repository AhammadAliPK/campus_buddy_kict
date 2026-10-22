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
// final shown = sampleCourses.where((c) => c.day == 'Wednesday').toList(); // ← NEW
final dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
};

final sortedCourses = [...sampleCourses];
sortedCourses.sort((a, b) {
  return dayOrder[a.day]!.compareTo(dayOrder[b.day]!);
});

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
    // NEW: Display total courses and credit hours
    Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          '${sampleCourses.length} courses · $totalCh credit hours',
        ),
      ),
    ),

Expanded(
child: sortedCourses.isEmpty
      ? const Center(
          child: Text('No classes! Alhamdulillah :)'),
        )
  :_isGrid
      ? GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          // itemCount: sampleCourses.length,
          // itemBuilder: (context, index) {
          //   final course = sampleCourses[index];
          itemCount: sortedCourses.length,
          itemBuilder: (context, index) {
            final course = sortedCourses[index];

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
          // itemCount: sampleCourses.length,
          // itemBuilder: (context, index) {
          //   final course = sampleCourses[index];
          itemCount: sortedCourses.length,
          itemBuilder: (context, index) {
            final course = sortedCourses[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  course.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),

            title: Text(course.code),
            subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.name),
                Text(
                  '${course.day.substring(0, 3)} ${course.time} · ${course.venue}',
                ),
                Text('${course.creditHours} Credit Hours'),
                Text('Instructor: ${course.instructor ?? 'TBA'}'),
                ],
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${course.code} tapped')),
              ),
              tileColor: index.isOdd
                  ? Colors.black.withValues(alpha: 0.03)
                  : null,
            );
          },
        ),
),

  ],
),
    );
  }
}