
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';
import 'package:campus_buddy_kict/screens/course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> _courses;

  bool _isGrid = false;
  bool _showMondayOnly = false;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  String _formatCredits(double credits) {
    return credits.toStringAsFixed(
      credits % 1 == 0 ? 0 : 1,
    );
  }

  double get _totalCreditHours {
    return _courses.fold<double>(
      0,
      (total, course) => total + course.creditHours,
    );
  }

  double get _enrolledCreditHours {
    return _courses
        .where((course) => course.enrolled)
        .fold<double>(
          0,
          (total, course) => total + course.creditHours,
        );
  }

  List<Course> get _displayedCourses {
    return _courses.where((course) {
      final matchesMonday = !_showMondayOnly ||
          course.day.toLowerCase().contains('monday');

      final matchesFavorite =
          !_showFavoritesOnly || course.isFavorite;

      return matchesMonday && matchesFavorite;
    }).toList();
  }

  void _toggleFavorite(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        isFavorite: !_courses[index].isFavorite,
      );
    });
  }

  void _toggleEnrolled(int index) {
    setState(() {
      _courses[index] = _courses[index].copyWith(
        enrolled: !_courses[index].enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final newCourse = await showDialog<Course>(
      context: context,
      builder: (_) => AddCourseDialog(
        existingCodes:
            _courses.map((course) => course.code).toList(),
      ),
    );

    if (!mounted || newCourse == null) return;

    setState(() {
      _courses.add(newCourse);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newCourse.code} added successfully'),
      ),
    );
  }

  Future<void> _openCourseDetails(Course course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(
          course: course,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _courses.remove(course);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course removed successfully'),
        ),
      );
    } else if (result is Course) {
      setState(() {
        final index = _courses.indexOf(course);

        if (index != -1) {
          _courses[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course updated successfully'),
        ),
      );
    }
  }

  void _showCourseDetails(Course course) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(course.code),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _detailRow(
                  Icons.school,
                  '${_formatCredits(course.creditHours)} Credit Hours',
                ),
                _detailRow(Icons.calendar_today, course.day),
                _detailRow(Icons.access_time, course.time),
                _detailRow(Icons.location_on, course.venue),
                _detailRow(
                  Icons.person,
                  course.instructor ?? 'Instructor not assigned',
                ),
                _detailRow(
                  course.isFavorite
                      ? Icons.star
                      : Icons.star_border,
                  course.isFavorite
                      ? 'Favourite'
                      : 'Not a favourite',
                ),
                _detailRow(
                  course.enrolled
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  course.enrolled
                      ? 'Enrolled'
                      : 'Not enrolled',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedCourses = _displayedCourses;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: 'Add course',
            onPressed: _addCourse,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: _showMondayOnly
                ? 'Show all days'
                : 'Show Monday courses',
            onPressed: () {
              setState(() {
                _showMondayOnly = !_showMondayOnly;
              });
            },
            icon: Icon(
              _showMondayOnly
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
          ),
          IconButton(
            tooltip: _isGrid ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
            icon: Icon(
              _isGrid ? Icons.view_list : Icons.grid_view,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Credit Hours',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_courses.length} courses',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enrolled: ${_formatCredits(_enrolledCreditHours)} CH',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_formatCredits(_totalCreditHours)} CH',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                FilterChip(
                  label: const Text('★ Favourites only'),
                  selected: _showFavoritesOnly,
                  onSelected: (selected) {
                    setState(() {
                      _showFavoritesOnly = selected;
                    });
                  },
                ),
                if (_showMondayOnly || _showFavoritesOnly)
                  ActionChip(
                    label: const Text('Clear filters'),
                    onPressed: () {
                      setState(() {
                        _showMondayOnly = false;
                        _showFavoritesOnly = false;
                      });
                    },
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _showFavoritesOnly
                        ? 'Favourite Courses (${displayedCourses.length})'
                        : _showMondayOnly
                            ? 'Monday Courses (${displayedCourses.length})'
                            : 'All Courses (${displayedCourses.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: displayedCourses.isEmpty
                ? const Center(
                    child: Text('No courses found.'),
                  )
                : _isGrid
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: displayedCourses.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];
                          final actualIndex =
                              _courses.indexOf(course);

                          return _buildCourseCard(
                            course,
                            actualIndex,
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        itemCount: displayedCourses.length,
                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];
                          final actualIndex =
                              _courses.indexOf(course);

                          return Material(
                            color: index.isEven
                                ? colorScheme.surfaceContainerHighest
                                : colorScheme.surface,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: course.enrolled
                                    ? Colors.green.shade100
                                    : colorScheme.primaryContainer,
                                child: Icon(
                                  course.enrolled
                                      ? Icons.check_circle
                                      : course.icon,
                                  color: course.enrolled
                                      ? Colors.green.shade700
                                      : colorScheme
                                          .onPrimaryContainer,
                                ),
                              ),
                              title: Text(
                                course.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${course.name}\n'
                                '${_formatCredits(course.creditHours)} CH • ${course.day}\n'
                                '${course.time}',
                              ),
                              isThreeLine: true,

                              // Tap opens Course Detail.
                              onTap: () =>
                                  _openCourseDetails(course),

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: course.isFavorite
                                        ? 'Remove favourite'
                                        : 'Add favourite',
                                    visualDensity:
                                        VisualDensity.compact,
                                    onPressed: () =>
                                        _toggleFavorite(actualIndex),
                                    icon: Icon(
                                      course.isFavorite
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: course.isFavorite
                                          ? Colors.amber
                                          : null,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Course details',
                                    visualDensity:
                                        VisualDensity.compact,
                                    onPressed: () =>
                                        _showCourseDetails(course),
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: course.enrolled
                                        ? 'Unenroll'
                                        : 'Enroll',
                                    visualDensity:
                                        VisualDensity.compact,
                                    onPressed: () =>
                                        _toggleEnrolled(actualIndex),
                                    icon: Icon(
                                      course.enrolled
                                          ? Icons.check_circle
                                          : Icons.add_task,
                                      color: course.enrolled
                                          ? Colors.green
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: index.isEven
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openCourseDetails(course),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: course.isFavorite
                        ? 'Remove favourite'
                        : 'Add favourite',
                    onPressed: () => _toggleFavorite(index),
                    icon: Icon(
                      course.isFavorite
                          ? Icons.star
                          : Icons.star_border,
                      color: course.isFavorite
                          ? Colors.amber
                          : null,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Course details',
                    onPressed: () =>
                        _showCourseDetails(course),
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              Icon(
                course.enrolled
                    ? Icons.check_circle
                    : course.icon,
                size: 36,
                color: course.enrolled
                    ? Colors.green
                    : colorScheme.primary,
              ),
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '${_formatCredits(course.creditHours)} CH',
              ),
              Text(
                course.day,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                course.enrolled
                    ? 'Enrolled ✓'
                    : 'Not enrolled',
                style: TextStyle(
                  color: course.enrolled
                      ? Colors.green.shade700
                      : colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: course.enrolled
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => _toggleEnrolled(index),
                child: Text(
                  course.enrolled ? 'Unenroll' : 'Enroll',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
