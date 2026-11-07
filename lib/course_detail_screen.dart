import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CourseDetailResult {
  final Course course;
  final bool removed;

  const CourseDetailResult(this.course, {this.removed = false});
}

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
  }

  void _toggleFavorite() {
    setState(() => _course = _course.copyWith(isFavorite: !_course.isFavorite));
  }

  void _toggleEnrolled() {
    setState(() => _course = _course.copyWith(enrolled: !_course.enrolled));
  }

  Future<void> _confirmRemove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Remove ${_course.code} from your courses?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.pop(context, CourseDetailResult(_course, removed: true));
  }

  Widget _row(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // send the (maybe edited) course back when the user goes back
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, CourseDetailResult(_course));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_course.code),
          actions: [
            IconButton(
              icon: Icon(
                _course.isFavorite ? Icons.star : Icons.star_border,
                color: _course.isFavorite ? Colors.amber : null,
              ),
              tooltip: 'Favourite',
              onPressed: _toggleFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove course',
              onPressed: _confirmRemove,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  _course.enrolled ? Icons.check_circle : _course.icon,
                  size: 44,
                  color:
                      _course.enrolled ? Colors.green : scheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _course.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                Chip(label: Text('${_course.creditHours} credit hours')),
                Chip(
                  label: Text(_course.enrolled ? 'Enrolled' : 'Not enrolled'),
                ),
              ],
            ),
            const Divider(height: 32),
            _row(Icons.calendar_today, 'Day', _course.day),
            _row(Icons.schedule, 'Time', _course.time),
            _row(Icons.place, 'Venue', _course.venue),
            _row(Icons.person, 'Instructor', _course.instructor ?? 'TBA'),
            const SizedBox(height: 16),
            _course.enrolled
                ? OutlinedButton.icon(
                    onPressed: _toggleEnrolled,
                    icon: const Icon(Icons.close),
                    label: const Text('Drop this course'),
                  )
                : FilledButton.icon(
                    onPressed: _toggleEnrolled,
                    icon: const Icon(Icons.check),
                    label: const Text('Enroll in this course'),
                  ),
          ],
        ),
      ),
    );
  }
}