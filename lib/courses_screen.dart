
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _showMondayOnly = false;

  @override
  Widget build(BuildContext context) {
    // Calculate total credit hours, including 0.5 credit courses.
    final totalCreditHours = sampleCourses.fold<double>(
      0,
      (total, course) => total + course.creditHours,
    );

    // Include courses held on Monday, including Monday & Wednesday classes.
    final displayedCourses = _showMondayOnly
        ? sampleCourses.where((course) {
            return course.day.toLowerCase().contains('monday');
          }).toList()
        : sampleCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: _showMondayOnly
                ? 'Show all courses'
                : 'Show Monday courses',
            icon: Icon(
              _showMondayOnly
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showMondayOnly = !_showMondayOnly;
              });
            },
          ),
          IconButton(
            tooltip: _isGrid ? 'List view' : 'Grid view',
            icon: Icon(
              _isGrid ? Icons.view_list : Icons.grid_view,
            ),
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
          // Total Credit Hours Card
          Card(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.school, size: 32),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Total Credit Hours',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    '${totalCreditHours.toStringAsFixed(1)} CH',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Course count and filter status
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _showMondayOnly
                        ? 'Monday Courses (${displayedCourses.length})'
                        : 'All Courses (${displayedCourses.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_showMondayOnly)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showMondayOnly = false;
                      });
                    },
                    child: const Text('Clear filter'),
                  ),
              ],
            ),
          ),

          // Course list or grid
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

                          return _buildCourseCard(
                            context,
                            course,
                            index,
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: displayedCourses.length,
                        itemBuilder: (context, index) {
                          final course = displayedCourses[index];

                          return Container(
                            color: index.isEven
                                ? Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                : Theme.of(context).colorScheme.surface,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Icon(
                                  course.icon,
                                  color: Theme.of(context)
                                      .colorScheme
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
                                '${course.creditHours} CH • ${course.day}\n'
                                '${course.time}',
                              ),
                              isThreeLine: true,
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                _showCourseDetails(context, course);
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Grid View course card
  Widget _buildCourseCard(
    BuildContext context,
    Course course,
    int index,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: index.isEven
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showCourseDetails(context, course);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                course.icon,
                size: 36,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                course.code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                course.name,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text('${course.creditHours} Credit Hours'),
              const SizedBox(height: 4),
              Text(
                course.day,
                textAlign: TextAlign.center,
              ),
              Text(
                course.time,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Display full details when a course is tapped
  void _showCourseDetails(
    BuildContext context,
    Course course,
  ) {
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
                  '${course.creditHours} Credit Hours',
                ),
                _detailRow(
                  Icons.calendar_today,
                  course.day,
                ),
                _detailRow(
                  Icons.access_time,
                  course.time,
                ),
                _detailRow(
                  Icons.location_on,
                  course.venue,
                ),
                _detailRow(
                  Icons.person,
                  course.instructor ?? 'Instructor not assigned',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
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
}
