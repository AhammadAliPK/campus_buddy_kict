import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static const Map<String, int> _dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  // A copy of the const list, so we can add and replace items.
  final List<Course> _courses = List.of(sampleCourses);
  bool _isGrid = false;
  String? _selectedDay; // null means "All days"

  // ---------- helpers ----------

  int get _totalCh {
    int total = 0;
    for (final c in _courses) {
      total = total + c.creditHours;
    }
    return total;
  }

  int get _enrolledCh {
    int total = 0;
    for (final c in _courses) {
      if (c.isEnrolled) total = total + c.creditHours;
    }
    return total;
  }

  int get _enrolledCount => _courses.where((c) => c.isEnrolled).length;

  // Filtered by day, then sorted by day and time.
  List<Course> get _shown {
    final list = _courses
        .where((c) => _selectedDay == null || c.day == _selectedDay)
        .toList();
    list.sort((a, b) {
      final byDay =
          (_dayOrder[a.day] ?? 8).compareTo(_dayOrder[b.day] ?? 8);
      return byDay != 0 ? byDay : a.time.compareTo(b.time);
    });
    return list;
  }

  String _shortDay(Course c) =>
      c.day.length > 3 ? c.day.substring(0, 3) : c.day;

  String _startTime(Course c) => c.time.split(RegExp(r'[-–]')).first;

  // Example: "Mon 09:00 · LT A"
  String _info(Course c) => '${_shortDay(c)} ${_startTime(c)} · ${c.venue}';

  // Replace-with-copy pattern (Week 5, section 5).
  void _replace(Course old, Course updated) {
    final i = _courses.indexOf(old);
    if (i == -1) return;
    setState(() => _courses[i] = updated);
  }

  void _toggleFavorite(Course c) =>
      _replace(c, c.copyWith(isFavorite: !c.isFavorite));

  void _setEnrolled(Course c, bool value) =>
      _replace(c, c.copyWith(isEnrolled: value));

  Future<void> _showAddDialog() async {
    final newCourse = await showDialog<Course>(
      context: context,
      builder: (context) => const _AddCourseDialog(),
    );
    if (newCourse == null || !mounted) return;
    setState(() => _courses.add(newCourse));
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    final shown = _shown;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: _isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_on),
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add course'),
      ),
      body: Column(
        children: [
          // Summary card
          Card(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_courses.length} courses · $_totalCh credit hours\n'
                'Enrolled: $_enrolledCount courses · $_enrolledCh credit hours',
              ),
            ),
          ),

          // Day filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedDay == null,
                  onSelected: (_) => setState(() => _selectedDay = null),
                ),
                for (final d in _days)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(d.substring(0, 3)),
                      selected: _selectedDay == d,
                      onSelected: (_) => setState(() => _selectedDay = d),
                    ),
                  ),
              ],
            ),
          ),

          // List / grid / empty message
          Expanded(
            child: shown.isEmpty
                ? const Center(child: Text('No classes! Alhamdulillah :)'))
                : _isGrid
                    ? _buildGrid(shown)
                    : _buildList(shown),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Course> shown) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 88),
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final course = shown[index];
        return ListTile(
          isThreeLine: true,
          tileColor: index.isOdd ? Colors.black.withValues(alpha: 0.03) : null,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              course.icon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text('${course.code} · ${course.creditHours} CH'),
          subtitle: Text(
            '${course.name}\n${_info(course)} · ${course.instructor ?? 'TBA'}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  course.isFavorite ? Icons.star : Icons.star_border,
                  color: course.isFavorite ? Colors.amber : null,
                ),
                tooltip: 'Favourite',
                onPressed: () => _toggleFavorite(course),
              ),
              Checkbox(
                value: course.isEnrolled,
                onChanged: (v) => _setEnrolled(course, v ?? false),
              ),
            ],
          ),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${course.code} tapped')),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<Course> shown) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final course = shown[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(course.icon, size: 32),
                const SizedBox(height: 4),
                Text(
                  course.code,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  course.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _info(course),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        course.isFavorite ? Icons.star : Icons.star_border,
                        color: course.isFavorite ? Colors.amber : null,
                      ),
                      onPressed: () => _toggleFavorite(course),
                    ),
                    Checkbox(
                      value: course.isEnrolled,
                      onChanged: (v) => _setEnrolled(course, v ?? false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------
// Popup form: Add a course (dialog + form + validators)
// ---------------------------------------------------------------
class _AddCourseDialog extends StatefulWidget {
  const _AddCourseDialog();

  @override
  State<_AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<_AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _chCtrl = TextEditingController(text: '3');
  final _timeCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  String _day = 'Monday';

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _chCtrl.dispose();
    _timeCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  void _save() {
    // Only continue when every validator returns null.
    if (!_formKey.currentState!.validate()) return;

    final time = _timeCtrl.text.trim().isEmpty ? 'TBA' : _timeCtrl.text.trim();
    final venue =
        _venueCtrl.text.trim().isEmpty ? 'TBA' : _venueCtrl.text.trim();

    Navigator.pop(
      context,
      Course(
        _codeCtrl.text.trim(),
        _nameCtrl.text.trim(),
        int.parse(_chCtrl.text.trim()),
        _day,
        Icons.book,
        time,
        venue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Course code'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Code is required';
                  }
                  if (!RegExp(r'^[A-Z]{4}\s?\d{4}$').hasMatch(value.trim())) {
                    return 'Use a format like CSCI 4311';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _chCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Credit hours'),
                validator: (value) {
                  final n = int.tryParse((value ?? '').trim());
                  if (n == null) return 'Enter a number';
                  if (n < 1 || n > 6) return 'Between 1 and 6';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _day,
                decoration: const InputDecoration(labelText: 'Day'),
                items: const [
                  DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                  DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
                  DropdownMenuItem(
                      value: 'Wednesday', child: Text('Wednesday')),
                  DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
                  DropdownMenuItem(value: 'Friday', child: Text('Friday')),
                ],
                onChanged: (v) => setState(() => _day = v ?? 'Monday'),
              ),
              TextFormField(
                controller: _timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (optional)',
                  hintText: '09:00-10:30',
                ),
              ),
              TextFormField(
                controller: _venueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Venue (optional)',
                  hintText: 'LT A',
                ),
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
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}