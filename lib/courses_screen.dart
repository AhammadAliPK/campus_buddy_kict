
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favoritesOnly = false;
  String _selectedDay = 'All';

  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  void _toggleFavorite(Course course) {
  setState(() {
    final index = _courses.indexWhere(
      (c) => c.code == course.code,
    );

    if (index != -1) {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    }
  });
}

void _toggleEnroll(Course course) {
  setState(() {
    final index = _courses.indexWhere((c) => c.code == course.code);

    if (index != -1) {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    }
  });
}

Future<void> _removeCourse(Course course) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Course'),
      content: Text(
        'Are you sure you want to remove ${course.code}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Remove',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  if (!mounted || confirm != true) return;

  setState(() {
    _courses.removeWhere((c) => c.code == course.code);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${course.code} removed successfully!'),
    ),
  );
}

Future<void> _openAddDialog() async {
  final newCourse = await showDialog<Course>(
    context: context,
    builder: (_) => AddCourseDialog(
      existingCodes: _courses.map((c) => c.code).toList(),
    ),
  );

  if (!mounted || newCourse == null) return;

  final isDuplicate = _courses.any(
    (course) =>
        course.code.replaceAll(' ', '').toUpperCase() ==
        newCourse.code.replaceAll(' ', '').toUpperCase(),
  );

  if (isDuplicate) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course code already exists!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() {
    _courses.add(newCourse);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${newCourse.code} added successfully!'),
    ),
  );
}

@override
Widget build(BuildContext context) {
    int totalCh = 0;

    for (final course in _courses) {
      totalCh += course.creditHours;
    }

    
    final dayOrder = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
    };

    final shown = _courses.where((course) {
      final matchesFavorite = !_favoritesOnly || course.isFavorite;

      final matchesDay = _selectedDay == 'All' ||
          course.day.split(' & ').contains(_selectedDay);

      return matchesFavorite && matchesDay;
    }).toList();

    shown.sort((a, b) {
      final aDay = a.day.split(' & ').first;
      final bDay = b.day.split(' & ').first;

      return (dayOrder[aDay] ?? 6).compareTo(dayOrder[bDay] ?? 6);
    });

    final enrolledCreditHours = _courses
        .where((course) => course.enrolled)
        .fold<int>(0, (total, course) => total + course.creditHours);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
            onPressed: _openAddDialog,
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      
body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedDay,
        decoration: const InputDecoration(
          labelText: 'Filter by Day',
          border: OutlineInputBorder(),
        ),
        items: [
          'All',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
        ].map((day) {
          return DropdownMenuItem(
            value: day,
            child: Text(day),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedDay = value;
            });
          }
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FilterChip(
          label: const Text('Favourites Only'),
          avatar: const Icon(Icons.star, size: 18),
          selected: _favoritesOnly,
          onSelected: (selected) {
            setState(() {
              _favoritesOnly = selected;
            });
          },
        ),
      ),
    ),

    Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_courses.length} courses · $totalCh credit hours',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Enrolled Credit Hours: $enrolledCreditHours',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    ),
    
Expanded(
  child: shown.isEmpty
      ? const Center(
          child: Text('No classes! Alhamdulillah :)'),
        )
      : _isGrid
      ? GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: shown.length,
          itemBuilder: (context, index) {
            final course = shown[index];

            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(course.icon, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    course.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      course.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  course.enrolled
                      ? Icons.check_circle
                      : course.icon,
                  color: course.enrolled
                      ? Colors.green
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              
              title: Text(course.code),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${course.name} · ${course.creditHours} CH'),
                  Text('${course.day} ${course.time} · ${course.venue}'),
                  Text('Lecturer: ${course.instructor ?? 'TBA'}'),
                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      course.enrolled
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: course.enrolled ? Colors.green : Colors.grey,
                    ),
                    tooltip: course.enrolled ? 'Unenroll' : 'Enroll',
                    onPressed: () => _toggleEnroll(course),
                  ),
                  IconButton(
                    icon: Icon(
                      course.isFavorite ? Icons.star : Icons.star_border,
                      color: course.isFavorite ? Colors.amber : Colors.grey,
                    ),
                    tooltip: 'Favourite',
                    onPressed: () => _toggleFavorite(course),
                  ),
                ],
              ),

              onTap: () => _toggleEnroll(course),
              onLongPress: () => _removeCourse(course),
            );
            
                    },
        ),
    ),
  ],
),
    );
  }
}