
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favourites_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;

  
Future<void> _clearFavourites() async {
  final confirmed = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => const ClearFavouritesScreen(),
    ),
  );

  if (!mounted) return;

  if (confirmed == true) {
    setState(() {
      for (int i = 0; i < sampleCourses.length; i++) {
        sampleCourses[i] = sampleCourses[i].copyWith(
          isFavorite: false,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All favourites cleared!'),
      ),
    );
  }
}


  void _showAddCourseDialog() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final creditController = TextEditingController();
    final dayController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Course'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Course Code',
                      prefixIcon: Icon(Icons.code),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter course code';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Course Name',
                      prefixIcon: Icon(Icons.book),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter course name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: creditController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Credit Hours',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator: (value) {
                      final number = int.tryParse(value ?? '');
                      if (number == null || number <= 0) {
                        return 'Enter valid credit hours';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dayController,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a day';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    sampleCourses.add(
                      Course(
                        codeController.text.trim(),
                        nameController.text.trim(),
                        int.parse(creditController.text.trim()),
                        dayController.text.trim(),
                        Icons.book,
                      ),
                    );
                  });

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Course added successfully!'),
                    ),
                  );
                }
              },
              child: const Text('Add Course'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCh = sampleCourses.fold<int>(
      0,
      (total, course) => total + course.creditHours,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          
IconButton(
  icon: const Icon(Icons.star_outline),
  tooltip: 'Clear All Favourites',
  onPressed: _clearFavourites,
),

          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Course',
            onPressed: _showAddCourseDialog,
          ),
          IconButton(
            icon: Icon(
              _isGrid ? Icons.list : Icons.grid_on,
            ),
            tooltip: _isGrid ? 'List View' : 'Grid View',
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
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${sampleCourses.length} courses · $totalCh credit hours',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: sampleCourses.length,
                    itemBuilder: (context, index) {
                      final course = sampleCourses[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      course.isFavorite
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: course.isFavorite
                                          ? Colors.amber
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        sampleCourses[index] =
                                            course.copyWith(
                                          isFavorite: !course.isFavorite,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Icon(course.icon, size: 36),
                              const SizedBox(height: 8),
                              Text(
                                course.code,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.name,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text('${course.creditHours} CH'),
                              Text(course.day),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: sampleCourses.length,
                    itemBuilder: (context, index) {
                      final course = sampleCourses[index];

                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: CircleAvatar(
                          child: Icon(course.icon),
                        ),
                        title: Text(course.code),
                        subtitle: Text(
                          '${course.name} · ${course.day}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${course.creditHours} CH'),
                            IconButton(
                              icon: Icon(
                                course.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: course.isFavorite
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  sampleCourses[index] =
                                      course.copyWith(
                                    isFavorite: !course.isFavorite,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        
onTap: () async {
  final selectedCourse = course;

  final result = await Navigator.push<Object?>(
    context,
    MaterialPageRoute(
      builder: (_) => CourseDetailScreen(
        course: selectedCourse,
      ),
    ),
  );

  if (!mounted) return;

  if (result == true) {
    setState(() {
      sampleCourses.remove(selectedCourse);
    });
  } else if (result is Course) {
    setState(() {
      final index = sampleCourses.indexOf(selectedCourse);

      if (index != -1) {
        sampleCourses[index] = result;
      }
    });
  }
},

                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
