import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/course.dart';
import '../services/launcher_service.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.appState,
    required this.onOpenCourses,
    required this.onOpenLinks,
    super.key,
  });

  final CampusBuddyState appState;
  final VoidCallback onOpenCourses;
  final VoidCallback onOpenLinks;

  @override
  Widget build(BuildContext context) {
    final courses = appState.courses.take(3).toList();
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Campus Buddy'),
            actions: [
              IconButton(
                tooltip: 'Campus map',
                onPressed: () => _runAction(context, LauncherService.openMap),
                icon: const Icon(Icons.map_outlined),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _WelcomeCard(appState: appState),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: '${appState.courses.length}',
                        label: 'Courses',
                        icon: Icons.menu_book,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        value: '${appState.totalCredits}',
                        label: 'Credit hours',
                        icon: Icons.school,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My timetable',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: onOpenCourses,
                      child: const Text('View all'),
                    ),
                  ],
                ),
                ...courses.map(
                  (course) =>
                      _CoursePreview(course: course, appState: appState),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.phone_in_talk),
                    ),
                    title: const Text('Need campus help?'),
                    subtitle: const Text('Call the IIUM security hotline'),
                    trailing: IconButton(
                      tooltip: 'Call hotline',
                      onPressed: () =>
                          _runAction(context, LauncherService.callHotline),
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.link)),
                    title: const Text('Campus links'),
                    subtitle: const Text(
                      'IIUM, KICT, map, hotline and advisor email',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onOpenLinks,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.info_outline),
                    ),
                    title: const Text('About Campus Buddy'),
                    subtitle: const Text(
                      'Student details and learning milestones',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runAction(
    BuildContext context,
    Future<bool> Function() action,
  ) async {
    if (await action() || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No suitable app is available on this device.'),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.appState});

  final CampusBuddyState appState;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                appState.nickname.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assalamu alaikum,',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    appState.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Section 1 · 2312887',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursePreview extends StatelessWidget {
  const _CoursePreview({required this.course, required this.appState});

  final Course course;
  final CampusBuddyState appState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: course.color,
          child: const Icon(Icons.book, color: Colors.white),
        ),
        title: Text(
          course.code,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${course.title}\n${course.day} · ${course.time}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                CourseDetailScreen(course: course, appState: appState),
          ),
        ),
      ),
    );
  }
}
