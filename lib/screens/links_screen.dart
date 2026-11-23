
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';

class LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;

  const LinkItem(this.title, this.subtitle, this.icon, this.uri);
}

const _links = [
  LinkItem(
    'IIUM Portal',
    'Student portal & registration',
    Icons.school,
    'https://my.iium.edu.my',
  ),
  LinkItem(
    'IIUM Website',
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
    'Kuliyyah of ICT',
    Icons.computer,
    'https://www.iium.edu.my/kict',
  ),
  LinkItem(
    'CELPAD',
    'Centre for Languages and Pre-University Academic Development',
    Icons.language,
    'https://centre.iium.edu.my/celpad/',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

  // Open link and handle failure
  Future<void> _open(BuildContext context, String uri) async {
    final ok = await LinkOpener.open(
      uri,
      inApp: _openInApp,
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open $uri on this device'),
        ),
      );
    }
  }

  // University hotline
  void _callHotline(BuildContext context) {
    _open(context, 'tel:+60361964000');
  }

  // Kuantan campus map
  void _openKuantanMap(BuildContext context) {
    final uri = Platform.isAndroid
        ? 'geo:3.84618,103.30821?q=IIUM Kuantan Campus'
        : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus&ll=3.84618,103.30821';

    _open(context, uri);
  }

  // Gombak campus map
  void _openGombakMap(BuildContext context) {
    final uri = Platform.isAndroid
        ? 'geo:3.0717,101.7182?q=IIUM Gombak Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus&ll=3.0717,101.7182';

    _open(context, uri);
  }

  // Personalised email
  void _emailAdvisor(BuildContext context) {
    // Replace these two placeholders with your actual details.
    const advisorEmail = 'ahammad.ali@live.iium.edu.my';
    const matricNumber = '2315928';

    final emailUri = Uri(
      scheme: 'mailto',
      path: advisorEmail,
      queryParameters: {
        'subject': 'Advising session',
        'body':
            'Assalamualaikum,\n\n'
            'I would like to book an advising session.\n'
            'My matric number is $matricNumber.\n\n'
            'Thank you.',
      },
    );

    _open(context, emailUri.toString());
  }

  // Share application
  void _share(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus links'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Open in-app switch
          Card(
            child: SwitchListTile(
              title: const Text('Open in-app'),
              subtitle: const Text(
                'Open websites inside Campus Buddy KICT',
              ),
              value: _openInApp,
              onChanged: (value) {
                setState(() {
                  _openInApp = value;
                });
              },
            ),
          ),

          // Website links
          ..._links.map(
            (link) => Card(
              child: ListTile(
                leading: Icon(link.icon),
                title: Text(link.title),
                subtitle: Text(link.subtitle),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _open(context, link.uri),
              ),
            ),
          ),

          const Divider(),

          // Kuantan map
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('IIUM Kuantan Campus Map'),
            subtitle: const Text('Open Kuantan campus location'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openKuantanMap(context),
          ),

          // Gombak map
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('IIUM Gombak Campus Map'),
            subtitle: const Text('Open Gombak campus location'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openGombakMap(context),
          ),

          // Hotline
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: () => _callHotline(context),
          ),

          // Email advisor
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text('Prefilled subject and body'),
            onTap: () => _emailAdvisor(context),
          ),

          const Divider(),

          // Share
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            onTap: () => _share(context),
          ),
        ],
      ),
    );
  }
}
