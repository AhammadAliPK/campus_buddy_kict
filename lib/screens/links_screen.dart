import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../app_state.dart';
import '../services/launcher_service.dart';

class LinksScreen extends StatefulWidget {
  const LinksScreen({required this.appState, super.key});

  final CampusBuddyState appState;

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

  Future<void> _open(Future<bool> Function() action) async {
    if (await action() || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No suitable app is available on this device.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final advisorConfigured = widget.appState.advisorEmail.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Open web links in-app'),
              subtitle: const Text(
                'Turn this off to use your default browser.',
              ),
              value: _openInApp,
              onChanged: (value) => setState(() => _openInApp = value),
            ),
          ),
          const SizedBox(height: 12),
          _LinkTile(
            icon: Icons.public,
            title: 'IIUM website',
            subtitle: 'News and announcements',
            onTap: () =>
                _open(() => LauncherService.openIiumWebsite(inApp: _openInApp)),
          ),
          _LinkTile(
            icon: Icons.school_outlined,
            title: 'Student portal',
            subtitle: 'Registration and student services',
            onTap: () => _open(
              () => LauncherService.openStudentPortal(inApp: _openInApp),
            ),
          ),
          _LinkTile(
            icon: Icons.computer_outlined,
            title: 'KICT website',
            subtitle: 'Kulliyyah of ICT',
            onTap: () =>
                _open(() => LauncherService.openWebsite(inApp: _openInApp)),
          ),
          _LinkTile(
            icon: Icons.language,
            title: 'CELPAD',
            subtitle: 'Language and pre-university services',
            onTap: () =>
                _open(() => LauncherService.openCelpad(inApp: _openInApp)),
          ),
          _LinkTile(
            icon: Icons.map_outlined,
            title: 'Campus map',
            subtitle: 'Open KICT IIUM in a map app',
            onTap: () => _open(LauncherService.openMap),
          ),
          _LinkTile(
            icon: Icons.phone_outlined,
            title: 'Campus hotline',
            subtitle: LauncherService.campusHotline,
            onTap: () => _open(LauncherService.callHotline),
          ),
          _LinkTile(
            icon: Icons.email_outlined,
            title: 'Academic advisor',
            subtitle: advisorConfigured
                ? widget.appState.advisorEmail
                : 'Configure your advisor email in More',
            onTap: advisorConfigured
                ? () => _open(
                    () => LauncherService.email(widget.appState.advisorEmail),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share links page'),
              subtitle: const Text('Send Campus Buddy to a classmate'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Share.share(
                'Campus Buddy KICT\nIIUM, KICT · Rafiq Hamsyari · 2312887',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new),
        onTap: onTap,
      ),
    );
  }
}
