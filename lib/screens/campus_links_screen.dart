import 'dart:io';

import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;

  const LinkItem(this.title, this.subtitle, this.icon, this.uri);
}

const _links = [
  LinkItem(
    'IIUM portal',
    'Student portal & registration',
    Icons.school,
    'https://my.iium.edu.my',
  ),
  LinkItem(
    'IIUM website',
    'News & announcements',
    Icons.public,
    'https://www.iium.edu.my',
  ),
  LinkItem(
    'Library',
    'Find books & e-resources',
    Icons.local_library,
    'https://division.iium.edu.my/lib',
  ),
  LinkItem(
    'KICT',
    'Kulliyyah of ICT',
    Icons.computer,
    'https://www.iium.edu.my/kict',
  ),
  LinkItem(
    'CELPAD',
    'Language courses and proficiency tests',
    Icons.translate,
    'https://centre.iium.edu.my/celpad/',
  ),
];

class CampusLinksScreen extends StatefulWidget {
  const CampusLinksScreen({super.key});

  @override
  State<CampusLinksScreen> createState() => _CampusLinksScreenState();
}

class _CampusLinksScreenState extends State<CampusLinksScreen> {
  bool _openInApp = false;

  Future<void> _open(
    String uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final opened = await LinkOpener.open(uri, mode: mode);

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot open this link on this device.'),
        ),
      );
    }
  }

  Future<void> _openGombakMap() {
    final uri = Platform.isAndroid
        ? 'geo:0,0?q=IIUM+Gombak+Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus';

    return _open(uri);
  }

  Future<void> _openKuantanMap() {
    const coordinates = '3.84618,103.30821';
    final label = Uri.encodeComponent('IIUM Kuantan Campus');

    final uri = Platform.isAndroid
        ? 'geo:0,0?q=$coordinates($label)'
        : 'https://maps.apple.com/?ll=$coordinates&q=$label';

    return _open(uri);
  }

  Future<void> _emailAdvisor() {
    const advisorEmail = 'zainab_senan@iium.edu.my';
    final subject = Uri.encodeComponent(
      'Request for academic advising session',
    );
    final body = Uri.encodeComponent(
      'Assalamualaikum,\n\n'
      'I am a Bachelor of Computer Science student. '
      'My matric number is 2318072.\n\n'
      'I would like to arrange an academic advising session. '
      'Please let me know a suitable date and time.\n\n'
      'Thank you.',
    );

    return _open('mailto:$advisorEmail?subject=$subject&body=$body');
  }

  Future<void> _share() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Campus Buddy KICT - built in CSCI 4311 at IIUM.',
        ),
      );
    } catch (error) {
      debugPrint('Could not open sharing: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot open sharing on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Links'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            title: const Text('Open in-app'),
            value: _openInApp,
            onChanged: (value) {
              setState(() {
                _openInApp = value;
              });
            },
          ),
          ..._links.map(
            (link) => Card(
              child: ListTile(
                leading: Icon(link.icon),
                title: Text(link.title),
                subtitle: Text(link.subtitle),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _open(
                  link.uri,
                  mode: _openInApp
                      ? LaunchMode.inAppBrowserView
                      : LaunchMode.externalApplication,
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Gombak campus map'),
            subtitle: const Text('Find IIUM Gombak Campus'),
            onTap: _openGombakMap,
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Kuantan campus map'),
            subtitle: const Text('Find IIUM Kuantan Campus'),
            onTap: _openKuantanMap,
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: () => _open('tel:+60361964000'),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text('Prefilled subject and body'),
            onTap: _emailAdvisor,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            onTap: _share,
          ),
        ],
      ),
    );
  }
}