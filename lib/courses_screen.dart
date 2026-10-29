
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

const Color _turquoise = Color(0xFF009FA3);
const Color _darkTurquoise = Color(0xFF007C80);
const Color _paleAqua = Color(0xFFEAF9F8);

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  bool _favoritesOnly = false;
  String _selectedDay = 'All Days';

  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = List.of(sampleCourses);
  }

  int get _totalCreditHours => _courses
      .where((course) => course.enrolled)
      .fold(0, (total, course) => total + course.creditHours);

  List<String> get _availableDays {
    final days = _courses
        .map((course) => course.day)
        .where((day) => day.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return ['All Days', ...days];
  }

  List<Course> get _visibleCourses {
    return _courses.where((course) {
      final matchesDay =
          _selectedDay == 'All Days' || course.day == _selectedDay;
      final matchesFavorite =
          !_favoritesOnly || course.isFavorite;

      return matchesDay && matchesFavorite;
    }).toList();
  }

  void _openCourse(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailsScreen(course: course),
      ),
    );
  }

  void _toggleFavorite(Course course) {
    final index = _courses.indexOf(course);
    if (index == -1) return;

    setState(() {
      _courses[index] = course.copyWith(
        isFavorite: !course.isFavorite,
      );
    });
  }

  void _toggleEnrollment(Course course) {
    final index = _courses.indexOf(course);
    if (index == -1) return;

    setState(() {
      _courses[index] = course.copyWith(
        enrolled: !course.enrolled,
      );
    });
  }

  Future<void> _addCourse() async {
    final Course? newCourse = await showDialog<Course>(
      context: context,
      builder: (context) => const AddCourseDialog(),
    );

    if (newCourse == null || !mounted) return;

    final alreadyExists = _courses.any(
      (course) =>
          course.code.trim().toLowerCase() ==
          newCourse.code.trim().toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${newCourse.code} already exists in your course list.',
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
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
        backgroundColor: _darkTurquoise,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Course?'),
        content: Text(
          'Are you sure you want to delete '
          '${course.code} - ${course.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() {
      _courses.remove(course);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${course.code} deleted successfully.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _darkTurquoise,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleCourses = _visibleCourses;

    return Scaffold(
      backgroundColor: _paleAqua,
      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: _paleAqua,
        actions: [
          IconButton(
            tooltip: _favoritesOnly
                ? 'Show all courses'
                : 'Show favourite courses',
            onPressed: () {
              setState(() {
                _favoritesOnly = !_favoritesOnly;
              });
            },
            icon: Icon(
              _favoritesOnly
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: _favoritesOnly
                  ? Colors.amber.shade700
                  : _darkTurquoise,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: _isGrid ? 'List view' : 'Grid view',
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                foregroundColor: _darkTurquoise,
              ),
              icon: Icon(
                _isGrid
                    ? Icons.view_list
                    : Icons.grid_view_rounded,
              ),
              onPressed: () {
                setState(() => _isGrid = !_isGrid);
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _AquaBackground(),
          SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                  child: _SemesterGlassCard(
                    courseCount: _courses.length,
                    creditHours: _totalCreditHours,
                  ),
                ),

                // Day filter and favourite filter.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _availableDays.contains(_selectedDay)
                                  ? _selectedDay
                                  : 'All Days',
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _darkTurquoise,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              items: _availableDays.map((day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(
                                    day,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _darkTurquoise,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (day) {
                                if (day == null) return;
                                setState(() => _selectedDay = day);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _favoritesOnly = !_favoritesOnly;
                          });
                        },
                        icon: Icon(
                          _favoritesOnly
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 19,
                        ),
                        label: Text(
                          _favoritesOnly ? 'Favorites' : 'All',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _favoritesOnly
                              ? Colors.amber.shade800
                              : _darkTurquoise,
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.85),
                          side: BorderSide(
                            color: _favoritesOnly
                                ? Colors.amber.shade300
                                : Colors.white,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Your Courses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _darkTurquoise,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Text(
                        '${visibleCourses.length} courses',
                        style: const TextStyle(
                          color: _darkTurquoise,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: visibleCourses.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _favoritesOnly
                                      ? Icons.star_border_rounded
                                      : Icons.menu_book_rounded,
                                  size: 54,
                                  color: _turquoise.withValues(alpha: 0.6),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _favoritesOnly
                                      ? 'No favourite courses yet'
                                      : 'No courses for this day',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: _darkTurquoise,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Try changing your filters.',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _isGrid
                          ? GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                18, 4, 18, 90,
                              ),
                              itemCount: visibleCourses.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 13,
                                mainAxisSpacing: 13,
                                childAspectRatio: 0.77,
                              ),
                              itemBuilder: (context, index) {
                                final course = visibleCourses[index];

                                return _CourseGridCard(
                                  course: course,
                                  onTap: () => _openCourse(course),
                                  onFavoriteTap: () =>
                                      _toggleFavorite(course),
                                  onEnrollmentTap: () =>
                                      _toggleEnrollment(course),
                                  onDelete: () => _deleteCourse(course),
                                );
                              },
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                18, 4, 18, 90,
                              ),
                              itemCount: visibleCourses.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 13),
                              itemBuilder: (context, index) {
                                final course = visibleCourses[index];

                                return _CourseListCard(
                                  course: course,
                                  onTap: () => _openCourse(course),
                                  onFavoriteTap: () =>
                                      _toggleFavorite(course),
                                  onEnrollmentTap: () =>
                                      _toggleEnrollment(course),
                                  onDelete: () => _deleteCourse(course),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCourse,
        backgroundColor: _darkTurquoise,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Course',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ============================================================
// AQUA BACKGROUND
// ============================================================

class _AquaBackground extends StatelessWidget {
  const _AquaBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF6FFFF),
              Color(0xFFE7F7F6),
              Color(0xFFF3FAFC),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 30,
              right: -65,
              child: _SoftOrb(size: 190),
            ),
            Positioned(
              bottom: 80,
              left: -80,
              child: _SoftOrb(size: 170),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftOrb extends StatelessWidget {
  final double size;

  const _SoftOrb({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _turquoise.withValues(alpha: 0.10),
            _turquoise.withValues(alpha: 0.025),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SEMESTER SUMMARY
// ============================================================

class _SemesterGlassCard extends StatelessWidget {
  final int courseCount;
  final int creditHours;

  const _SemesterGlassCard({
    required this.courseCount,
    required this.creditHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14B9B6),
            Color(0xFF009FA3),
            Color(0xFF007C80),
          ],
        ),
        borderRadius: BorderRadius.circular(29),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _darkTurquoise.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -38,
            right: -25,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 18,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.19),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Icon(
                      Icons.waving_hand_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Text(
                    'ASSALAMUALAIKUM!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              const Text(
                'Your Semester\nat a Glance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _SummaryGlassItem(
                      icon: Icons.menu_book_rounded,
                      value: '$courseCount',
                      label: 'Courses',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryGlassItem(
                      icon: Icons.school_rounded,
                      value: '$creditHours',
                      label: 'Enrolled credit hours',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryGlassItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryGlassItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.17),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 25),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFE0FFFF),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SHARED GLASS STYLE
// ============================================================

BoxDecoration _glassDecoration({double radius = 24}) {
  return BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xF4F8FFFF),
        Color(0xEAF0FBFA),
      ],
    ),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.98),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: _darkTurquoise.withValues(alpha: 0.10),
        blurRadius: 19,
        offset: const Offset(0, 9),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.85),
        blurRadius: 5,
        offset: const Offset(-2, -2),
      ),
    ],
  );
}

// ============================================================
// COURSE LIST CARD
// ============================================================

class _CourseListCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onEnrollmentTap;
  final VoidCallback onDelete;

  const _CourseListCard({
    required this.course,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onEnrollmentTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _glassDecoration(radius: 23),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          onTap: onEnrollmentTap,
          onLongPress: onDelete,
          borderRadius: BorderRadius.circular(23),
          splashColor: _turquoise.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _CourseIcon(course: course, size: 57),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.code,
                        style: const TextStyle(
                          color: _darkTurquoise,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF243B3D),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 5,
                        children: [
                          _MiniPill(
                            icon: Icons.school_outlined,
                            text: '${course.creditHours} CH',
                          ),
                          _MiniPill(
                            icon: Icons.calendar_today_outlined,
                            text: course.day,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: course.isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: onFavoriteTap,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    course.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: course.isFavorite
                        ? Colors.amber.shade700
                        : _turquoise,
                    size: 25,
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: course.enrolled
                        ? Colors.green.withValues(alpha: 0.12)
                        : _turquoise.withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    course.enrolled
                        ? Icons.check_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: course.enrolled
                        ? Colors.green
                        : _darkTurquoise,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COURSE GRID CARD
// ============================================================

class _CourseGridCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onEnrollmentTap;
  final VoidCallback onDelete;

  const _CourseGridCard({
    required this.course,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onEnrollmentTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _glassDecoration(radius: 24),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          onLongPress: onDelete,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CourseIcon(course: course, size: 53),
                    IconButton(
                      tooltip: course.isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: onFavoriteTap,
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        course.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: course.isFavorite
                            ? Colors.amber.shade700
                            : _turquoise,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  course.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _darkTurquoise,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Expanded(
                  child: Text(
                    course.name,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF243B3D),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _paleAqua,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${course.creditHours} credit hours',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _darkTurquoise,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (course.enrolled)
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COURSE ICON AND PILL
// ============================================================

class _CourseIcon extends StatelessWidget {
  final Course course;
  final double size;

  const _CourseIcon({
    required this.course,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFDFF8F5),
            Color(0xFFC8EBE7),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _turquoise.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Icon(
        course.icon,
        color: _darkTurquoise,
        size: size * 0.48,
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _paleAqua,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _turquoise.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _turquoise),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: _darkTurquoise,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COURSE DETAILS SCREEN
// ============================================================

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paleAqua,
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: _paleAqua,
      ),
      body: Stack(
        children: [
          const _AquaBackground(),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CourseHero(course: course),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'Class Information',
                      style: TextStyle(
                        color: _darkTurquoise,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  _DetailGlassTile(
                    icon: Icons.calendar_month_rounded,
                    title: 'Class day',
                    value: course.day,
                  ),
                  _DetailGlassTile(
                    icon: Icons.access_time_filled_rounded,
                    title: 'Class time',
                    value: course.time,
                  ),
                  _DetailGlassTile(
                    icon: Icons.location_on_rounded,
                    title: 'Classroom',
                    value: course.venue,
                  ),
                  _DetailGlassTile(
                    icon: Icons.person_rounded,
                    title: 'Lecturer',
                    value: course.lecturer,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 53,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text(
                        'Back to My Courses',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _darkTurquoise,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseHero extends StatelessWidget {
  final Course course;

  const _CourseHero({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14B9B6),
            Color(0xFF009FA3),
            Color(0xFF007C80),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _darkTurquoise.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFDDF5F2),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              course.icon,
              color: _darkTurquoise,
              size: 39,
            ),
          ),
          const SizedBox(height: 19),
          Text(
            course.code,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD9FFFF),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            course.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 23,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.42),
              ),
            ),
            child: Text(
              '${course.creditHours} Credit Hours',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailGlassTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailGlassTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _glassDecoration(radius: 21),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFDDF5F2),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: _darkTurquoise,
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF648082),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF243B3D),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
