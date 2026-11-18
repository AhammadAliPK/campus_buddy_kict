import 'package:flutter/material.dart';

import '../add_course_dialog.dart';
import '../app_state.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({required this.appState, super.key});

  final CampusBuddyState appState;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _query = '';
  bool _showFavourites = false;
  bool _isGrid = false;

  Future<void> _addCourse() async {
    final course = await showDialog<Course>(
      context: context,
      builder: (_) => const AddCourseDialog(),
    );
    if (course == null) return;
    if (widget.appState.courses.any((item) => item.code == course.code)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A course with that code already exists.'),
        ),
      );
      return;
    }
    widget.appState.addCourse(course);
  }

  Future<void> _clearFavourites() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all favourites?'),
        content: const Text('This removes the star from every course.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (shouldClear == true) widget.appState.clearFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCourses = widget.appState.courses.where((course) {
      final matchesQuery = '${course.code} ${course.title}'
          .toLowerCase()
          .contains(_query.toLowerCase());
      return matchesQuery && (!_showFavourites || course.isFavourite);
    }).toList();
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('My Courses'),
            actions: [
              IconButton(
                tooltip: _isGrid ? 'List view' : 'Grid view',
                onPressed: () => setState(() => _isGrid = !_isGrid),
                icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
              ),
              IconButton(
                tooltip: 'Favourite courses',
                onPressed: () =>
                    setState(() => _showFavourites = !_showFavourites),
                icon: Icon(_showFavourites ? Icons.star : Icons.star_border),
              ),
              IconButton(
                tooltip: 'Add course',
                onPressed: _addCourse,
                icon: const Icon(Icons.add),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SearchBar(
                  hintText: 'Search courses',
                  leading: const Icon(Icons.search),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.appState.courses.length} courses · ${widget.appState.totalCourseCredits} credit hours',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.appState.enrolledCourseCount} enrolled · ${widget.appState.totalCredits} enrolled credit hours',
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _clearFavourites,
                        icon: const Icon(Icons.star_border),
                        label: const Text('Clear all favourites'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isGrid)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _CourseCard(
                    course: visibleCourses[index],
                    appState: widget.appState,
                    compact: true,
                  ),
                  childCount: visibleCourses.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.builder(
                itemCount: visibleCourses.length,
                itemBuilder: (context, index) => _CourseCard(
                  course: visibleCourses[index],
                  appState: widget.appState,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
    required this.appState,
    this.compact = false,
  });

  final Course course;
  final CampusBuddyState appState;
  final bool compact;

  Future<void> _remove(BuildContext context) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${course.code}?'),
        content: const Text('The course will be removed from this device.'),
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
    if (shouldRemove == true) appState.removeCourse(course.code);
  }

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: EdgeInsets.only(bottom: compact ? 0 : 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                CourseDetailScreen(course: course, appState: appState),
          ),
        ),
        onLongPress: () => _remove(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: course.color,
                      child: const Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.code,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text('${course.credits} CH · ${course.day}'),
                    Row(
                      children: [
                        _StarButton(course: course, appState: appState),
                        Expanded(
                          child: Switch(
                            value: course.isEnrolled,
                            onChanged: (value) => appState.updateCourse(
                              course.code,
                              course.copyWith(isEnrolled: value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: course.color,
                      radius: 25,
                      child: const Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.code,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            course.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${course.day} · ${course.time}\n${course.room}\n${course.credits} credit hours · Section ${course.section}',
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        _StarButton(course: course, appState: appState),
                        Switch(
                          value: course.isEnrolled,
                          onChanged: (value) => appState.updateCourse(
                            course.code,
                            course.copyWith(isEnrolled: value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
    return compact
        ? card
        : Padding(padding: const EdgeInsets.only(bottom: 12), child: card);
  }
}

class _StarButton extends StatelessWidget {
  const _StarButton({required this.course, required this.appState});

  final Course course;
  final CampusBuddyState appState;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: course.isFavourite ? 'Unstar course' : 'Star course',
      onPressed: () => appState.updateCourse(
        course.code,
        course.copyWith(isFavourite: !course.isFavourite),
      ),
      icon: Icon(
        course.isFavourite ? Icons.star : Icons.star_border,
        color: course.isFavourite ? Colors.amber : null,
      ),
    );
  }
}
