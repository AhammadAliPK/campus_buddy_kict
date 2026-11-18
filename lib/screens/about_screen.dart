import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Campus Buddy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(
            Icons.school,
            size: 76,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Campus Buddy KICT',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'A Flutter companion for course planning, notes and useful IIUM links.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Student'),
                  subtitle: Text('Rafiq Hamsyari'),
                ),
                ListTile(
                  leading: Icon(Icons.badge_outlined),
                  title: Text('Matric number'),
                  subtitle: Text('2312887'),
                ),
                ListTile(
                  leading: Icon(Icons.groups_outlined),
                  title: Text('Section'),
                  subtitle: Text('Section 1'),
                ),
                ListTile(
                  leading: Icon(Icons.menu_book_outlined),
                  title: Text('Course'),
                  subtitle: Text('CSCI 4311 · Mobile Application Development'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Implemented learning milestones',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Weeks 3–7: profile, course model, timetable, add/star/enrol, app shell, course details, About page, campus links and sharing.',
          ),
        ],
      ),
    );
  }
}
