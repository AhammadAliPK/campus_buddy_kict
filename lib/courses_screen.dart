import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/data/courses.dart'; // Still contains sampleCourses

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  // Convert the const list into a mutable list in State so we can update it
  late List<Course> _myCourses; 
  
  // Form Keys and Controllers for the Dialog
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myCourses = List.of(sampleCourses); // Start with your sample data
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // Opens a Dialog with a Form to add a new course
  Future<void> _showAddCourseDialog() async {
    _codeCtrl.clear();
    _nameCtrl.clear();

    final bool? added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Course'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Code is required';
                  }
                  if (!value.trim().startsWith(RegExp(r'^[A-Z]{4}'))) {
                    return 'Start with 4 letters, e.g. CSCI';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) => 
                    (value == null || value.isEmpty) ? 'Name is required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (added == true) {
      setState(() {
        _myCourses.add(
          Course(
            _codeCtrl.text.trim(),
            _nameCtrl.text.trim(),
            3, // Defaulting CH for the example
            'TBA',
            Icons.book,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in _myCourses) {
      totalCh = totalCh + c.creditHours;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('${_myCourses.length} courses, $totalCh credit hours'),
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _myCourses.length,
                    itemBuilder: (context, index) {
                      final course = _myCourses[index];
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
                    itemCount: _myCourses.length,
                    itemBuilder: (context, index) {
                      final course = _myCourses[index];
                      return CheckboxListTile(
                        tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
                        secondary: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(course.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        title: Text(course.code),
                        subtitle: Text('${course.name} \n${course.creditHours} CH'),
                        value: course.isEnrolled,
                        onChanged: (bool? newValue) {
                          setState(() {
                            // Using the copyWith pattern to replace the object
                            _myCourses[index] = course.copyWith(isEnrolled: newValue);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}