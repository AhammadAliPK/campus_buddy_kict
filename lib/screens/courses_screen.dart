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
  final List<Course> _courses = List.of(sampleCourses);

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index, bool? v) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isEnrolled: v ?? false,
      );
    });
  }

  // Open detail page; handle both Remove (true) and Edit (Course) results
  Future<void> _openCourseDetail(Course course) async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );

    final targetIndex = _courses.indexOf(course);
    if (targetIndex == -1) return;

    if (result == true) {
      setState(() => _courses.removeAt(targetIndex));
    } else if (result is Course) {
      setState(() => _courses[targetIndex] = result);
    }
  }

  // In-Class Exercise: Clear all favourites from Courses tab
  Future<void> _confirmAndClearFavourites() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClearFavouritesScreen(),
      ),
    );

    if (confirmed == true) {
      setState(() {
        for (int i = 0; i < _courses.length; i++) {
          _courses[i] = _courses[i].copyWith(isFavorite: false);
        }
      });
    }
  }

  Future<void> _showAddCourseDialog() async {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final timeController = TextEditingController(text: '10:00 - 11:30');
    final venueController = TextEditingController(text: 'KICT Lab 1');
    final instructorController = TextEditingController();

    String selectedDay = 'Monday';
    double creditHours = 3;

    final newCourse = await showDialog<Course>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add a course'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Course code',
                      hintText: 'e.g. CSCI 4311',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Code is required';
                      }
                      if (!value.trim().startsWith(RegExp(r'^[A-Z]{4}'))) {
                        return 'Start with 4 letters, e.g. CSCI 4311';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Course name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Course name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(labelText: 'Time'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: venueController,
                    decoration: const InputDecoration(labelText: 'Venue'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: instructorController,
                    decoration: const InputDecoration(
                      labelText: 'Instructor (leave blank for TBA)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Day', style: TextStyle(fontWeight: FontWeight.bold)),
                  for (final day in [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                  ])
                    RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(day),
                      value: day,
                      groupValue: selectedDay,
                      onChanged: (v) => setDialogState(() => selectedDay = v!),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Credit hours: ${creditHours.round()} CH',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    min: 1,
                    max: 4,
                    divisions: 3,
                    value: creditHours,
                    label: '${creditHours.round()}',
                    onChanged: (v) => setDialogState(() => creditHours = v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final instructorText = instructorController.text.trim();
                  Navigator.pop(
                    context,
                    Course(
                      codeController.text.trim(),
                      nameController.text.trim(),
                      creditHours.round(),
                      selectedDay,
                      Icons.book,
                      timeController.text.trim().isEmpty
                          ? 'TBA'
                          : timeController.text.trim(),
                      venueController.text.trim().isEmpty
                          ? 'TBA'
                          : venueController.text.trim(),
                      instructorText.isEmpty ? null : instructorText,
                      false,
                      true,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (newCourse != null) {
      setState(() {
        _courses.add(newCourse);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int enrolledCount = 0;
    int enrolledCh = 0;
    for (final c in _courses) {
      if (c.isEnrolled) {
        enrolledCount++;
        enrolledCh += c.creditHours;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            tooltip: 'Clear all favourites',
            onPressed: _confirmAndClearFavourites,
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_courses.length} courses • $enrolledCount enrolled ($enrolledCh credit hours)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return Card(
                        child: InkWell(
                          onTap: () => _openCourseDetail(course),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 4,
                                left: 4,
                                child: Checkbox(
                                  value: course.isEnrolled,
                                  onChanged: (v) => _toggleEnrolled(index, v),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: Icon(
                                    course.isFavorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color:
                                        course.isFavorite ? Colors.amber : null,
                                  ),
                                  onPressed: () => _toggleFavorite(index),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 16),
                                    Icon(course.icon, size: 36),
                                    const SizedBox(height: 8),
                                    Text(
                                      course.code,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        course.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${course.creditHours} CH',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return ListTile(
                        tileColor: index.isOdd
                            ? Colors.black.withValues(alpha: 0.03)
                            : null,
                        leading: Checkbox(
                          value: course.isEnrolled,
                          onChanged: (v) => _toggleEnrolled(index, v),
                        ),
                        title: Text(
                          '${course.code} (${course.creditHours} CH)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${course.name}\n${course.day} ${course.time} - ${course.venue}\n${course.instructor ?? 'TBA'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            course.isFavorite ? Icons.star : Icons.star_border,
                            color: course.isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleFavorite(index),
                        ),
                        onTap: () => _openCourseDetail(course),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCourseDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add course'),
      ),
    );
  }
}