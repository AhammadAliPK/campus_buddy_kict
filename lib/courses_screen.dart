import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/models/course.dart';
import 'package:campus_buddy_kict/add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool isGrid = false;
  late List<Course> courses;

  @override
  void initState() {
    super.initState();
    courses = List.of(sampleCourses);
  }

  void toggleFavorite(int index) {
    setState(() {
      courses[index] = courses[index].copyWith(
        isFavorite: !courses[index].isFavorite,
      );
    });
  }

  void toggleEnrolled(int index) {
    setState(() {
      courses[index] = courses[index].copyWith(
        enrolled: !courses[index].enrolled,
      );
    });
  }

  Future<void> addCourse() async {
    final course = await showCupertinoDialog<Course>(
      context: context,
      builder: (context) => const AddCourseDialog(),
    );
    if (course == null) return;
    setState(() => courses.add(course));
  }

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in courses) {
      totalCh += c.creditHours;
    }

    final enrolledCh = courses
        .where((c) => c.enrolled)
        .fold<int>(0, (sum, c) => sum + c.creditHours);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Courses'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: addCourse,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            isGrid ? CupertinoIcons.square_grid_2x2 : CupertinoIcons.list_bullet,
          ),
          onPressed: () => setState(() => isGrid = !isGrid),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${courses.length} courses • $totalCh CH\nEnrolled: $enrolledCh CH',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isGrid
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(8),
                            onPressed: () => toggleEnrolled(index),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  course.enrolled
                                      ? CupertinoIcons.check_mark_circled_solid
                                      : course.icon,
                                  size: 32,
                                  color: course.enrolled
                                      ? CupertinoColors.activeGreen
                                      : CupertinoColors.activeBlue,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  course.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: CupertinoColors.label,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  course.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(10),
                            onPressed: () => toggleEnrolled(index),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: course.enrolled
                                        ? CupertinoColors.activeGreen
                                            .withOpacity(0.12)
                                        : CupertinoColors.activeBlue
                                            .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    course.enrolled
                                        ? CupertinoIcons.check_mark_circled_solid
                                        : course.icon,
                                    color: course.enrolled
                                        ? CupertinoColors.activeGreen
                                        : CupertinoColors.activeBlue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.code,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: CupertinoColors.label,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${course.name} • ${course.day}',
                                        style: const TextStyle(
                                          color: CupertinoColors.systemGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Icon(
                                    course.isFavorite
                                        ? CupertinoIcons.star_fill
                                        : CupertinoIcons.star,
                                    color: course.isFavorite
                                        ? CupertinoColors.systemYellow
                                        : CupertinoColors.systemGrey,
                                  ),
                                  onPressed: () => toggleFavorite(index),
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
      ),
    );
  }
}