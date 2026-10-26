import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _selectedDay = 'Monday'; 
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    final shown = sampleCourses.where((c) => c.day == _selectedDay).toList(); 

    // Map days to numbers and sort the list
    final Map<String, int> dayMap = {
      'Monday': 1, 'Tuesday': 2, 'Wednesday': 3, 
      'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7
    };
    shown.sort((a, b) => dayMap[a.day]!.compareTo(dayMap[b.day]!));

    int totalCh = 0;
    for (final c in shown) { 
      totalCh = totalCh + c.creditHours;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            tooltip: 'Toggle view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('${shown.length} courses · $totalCh credit hours'),
            ),
          ),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _days.map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _selectedDay = day;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

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
                        subtitle: Text(
                          '${course.day} ${course.time} · ${course.venue}\nInstructor: ${course.instructor ?? 'TBA'}'
                        ),
                        isThreeLine: true,
                        trailing: Text('${course.creditHours} CH'),
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