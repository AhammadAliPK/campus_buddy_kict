import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _selectedDay = 'All';
  @override
  Widget build(BuildContext context) {
    int totalCh = 0; 
    for (final c in sampleCourses) { 
      totalCh = totalCh + c.creditHours; 
    }
    final shown = _selectedDay == 'All'
    ? sampleCourses
    : sampleCourses.where((c) => c.day == _selectedDay).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
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
              child: Text('${sampleCourses.length} courses | $totalCh credit hours'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (bool selected) {
                      setState(() => _selectedDay = day); // Updates memory and redraws screen
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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
                                  Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(course.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                          tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(course.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                          title: Text(course.code),
                          subtitle: Text('${course.name} ${course.creditHours} CH'),
                          trailing: Text(course.day),
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