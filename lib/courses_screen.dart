import 'package:flutter/material.dart';

// The Model Class
class Course {
  final String code;
  final String name;
  final int creditHours;
  final IconData icon;
  final String day;

  const Course(this.code, this.name, this.creditHours, this.icon, this.day);
}

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  // This state variable remembers if we are looking at a grid or a list
  bool _isGrid = false;

  final List<Course> _courses = const [
    Course(
      'CSCI 4311',
      'Mobile Application Development',
      3,
      Icons.phone_iphone,
      'Mon & Wed',
    ),
    Course('CSCI 4343', 'Data Science', 3, Icons.analytics, 'Tue & Thu'),
    Course('CSCI 3302', 'Network Security', 3, Icons.security, 'Mon & Wed'),
    Course('INFO 3305', 'Web Technologies', 3, Icons.web, 'Friday'),
    Course('UNGS 2011', 'Creative Thinking', 2, Icons.lightbulb, 'Tue & Thu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          // The toggle button in the top right
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              // setState rebuilds the screen with the new layout
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      // If _isGrid is true, show GridView; otherwise, show ListView
      body: _isGrid
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                mainAxisSpacing: 12, // Vertical gap
                crossAxisSpacing: 12, // Horizontal gap
                childAspectRatio: 0.85, // Adjusts card height/width ratio
              ),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped on ${course.code}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(course.icon, size: 48, color: Colors.teal),
                          const SizedBox(height: 8),
                          Text(
                            course.code,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(course.icon, size: 36, color: Colors.teal),
                    title: Text(
                      course.code,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(course.name),
                    trailing: Text(
                      course.day,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped on ${course.code}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
