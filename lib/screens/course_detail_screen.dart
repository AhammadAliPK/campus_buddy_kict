import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../app_state.dart';
import '../models/course.dart';
import 'edit_course_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    required this.course,
    required this.appState,
    super.key,
  });

  final Course course;
  final CampusBuddyState appState;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _course;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
    _noteController = TextEditingController(text: _course.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _editCourse() async {
    final updated = await Navigator.of(context).push<Course>(
      MaterialPageRoute(builder: (_) => EditCourseScreen(course: _course)),
    );
    if (updated == null) return;
    widget.appState.updateCourse(_course.code, updated);
    setState(() => _course = updated);
  }

  void _saveCourse() {
    final updated = _course.copyWith(note: _noteController.text);
    widget.appState.updateCourse(_course.code, updated);
    setState(() => _course = updated);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Course note saved.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_course.code),
        actions: [
          IconButton(
            tooltip: 'Edit course',
            onPressed: _editCourse,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Share course',
            onPressed: () => Share.share(
              '${_course.code} - ${_course.title}\n${_course.day}, ${_course.time}\n${_course.room}',
            ),
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            tooltip: 'Favourite',
            onPressed: () {
              final updated = _course.copyWith(
                isFavourite: !_course.isFavourite,
              );
              widget.appState.updateCourse(_course.code, updated);
              setState(() => _course = updated);
            },
            icon: Icon(_course.isFavourite ? Icons.star : Icons.star_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _course.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _course.code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _course.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  '${_course.credits} credit hours · Section ${_course.section}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _InfoTile(
            icon: Icons.schedule,
            label: 'Schedule',
            value: '${_course.day} · ${_course.time}',
          ),
          _InfoTile(
            icon: Icons.location_on_outlined,
            label: 'Venue',
            value: _course.room,
          ),
          _InfoTile(
            icon: Icons.person_outline,
            label: 'Lecturer',
            value: _course.lecturer,
          ),
          _InfoTile(
            icon: Icons.how_to_reg_outlined,
            label: 'Status',
            value: _course.isEnrolled ? 'Enrolled' : 'Not enrolled',
          ),
          const SizedBox(height: 12),
          Text(
            'About this course',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(_course.description),
          const SizedBox(height: 24),
          Text(
            'Personal note',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add a reminder for this course',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _saveCourse,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save note'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(value),
    );
  }
}
