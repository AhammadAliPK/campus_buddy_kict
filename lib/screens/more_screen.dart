import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../app_state.dart';
import '../services/launcher_service.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({required this.appState, super.key});

  final CampusBuddyState appState;

  Future<void> _showAdvisorDialog(BuildContext context) async {
    final controller = TextEditingController(text: appState.advisorEmail);
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advisor email'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter your advisor email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (email != null) appState.updateAdvisorEmail(email);
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

  @override
  Widget build(BuildContext context) {
    final advisorLabel = appState.advisorEmail.isEmpty
        ? 'Not configured'
        : appState.advisorEmail;
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Open campus links page'),
                  subtitle: const Text('Web links, map, hotline and sharing'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, '/links'),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Campus Buddy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, '/about'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Campus links',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.public),
                  title: const Text('KICT website'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _runAction(context, LauncherService.openWebsite),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: const Text('IIUM student portal'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () =>
                      _runAction(context, LauncherService.openStudentPortal),
                ),
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: const Text('Open campus map'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _runAction(context, LauncherService.openMap),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Contacts',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_in_talk),
                  title: const Text('IIUM security hotline'),
                  subtitle: const Text(LauncherService.campusHotline),
                  trailing: const Icon(Icons.call),
                  onTap: () => _runAction(context, LauncherService.callHotline),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Academic advisor'),
                  subtitle: Text(advisorLabel),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _showAdvisorDialog(context),
                  ),
                  onTap: appState.advisorEmail.isEmpty
                      ? () => _showAdvisorDialog(context)
                      : () => _runAction(
                          context,
                          () => LauncherService.email(appState.advisorEmail),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Campus Buddy'),
              subtitle: const Text('Send the project details to a classmate'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Share.share(
                'Campus Buddy KICT\nRafiq Hamsyari · 2312887 · Section 1\nA Flutter companion for courses, notes and campus links.',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About this app',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Campus Buddy KICT brings together the weekly course timetable, profile, notes, campus links, map, hotline and sharing tools for CSCI 4311.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Student: Rafiq Hamsyari\nMatric: 2312887\nSection: 1',
                    style: Theme.of(context).textTheme.bodySmall,
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
