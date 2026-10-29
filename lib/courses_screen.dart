import 'package:flutter/cupertino.dart';
import 'package:campus_buddy_kict/data/courses.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool isGrid = false;

  @override
  Widget build(BuildContext context) {
    int totalCh = 0;
    for (final c in sampleCourses) {
      totalCh += c.creditHours;
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Courses'),
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
            // Summary Card
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
                    'Total Courses',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '${sampleCourses.length} courses • $totalCh CH',
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
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
                      itemCount: sampleCourses.length,
                      itemBuilder: (context, index) {
                        final course = sampleCourses[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(8),
                            onPressed: () => _showCourseDialog(context, course.code, course.name),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(course.icon, size: 32, color: CupertinoColors.activeBlue),
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
                      itemCount: sampleCourses.length,
                      itemBuilder: (context, index) {
                        final course = sampleCourses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(10),
                            onPressed: () => _showCourseDialog(context, course.code, course.name),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.activeBlue.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(course.icon, color: CupertinoColors.activeBlue, size: 22),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        '${course.name} • ${course.creditHours} CH',
                                        style: const TextStyle(
                                          color: CupertinoColors.systemGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  course.day,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 12,
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
      ),
    );
  }

  void _showCourseDialog(BuildContext context, String code, String name) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(code),
        content: Text('$name tapped!'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}