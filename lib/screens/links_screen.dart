import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkItem {
  final String title, subtitle;
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
    'Kuliyyah of ICT',
    Icons.computer,
    'https://www.iium.edu.my/kict',
  ),
  LinkItem(
    'CELPAD',
    'Centre for Languages and Pre-University Academic Development',
    Icons.language,
    // 'https://centre.iium.edu.my/celpad/' another link to test.
    'https://www.iium.edu.my/celpad/',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

  Future<void> _open(BuildContext context, String uri) async {
    final isWebsite = uri.startsWith('https://') || uri.startsWith('http://');

    final mode = isWebsite && _openInApp
        ? LaunchMode.inAppBrowserView
        : LaunchMode.externalApplication;

    final ok = await LinkOpener.open(uri, mode: mode);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline(BuildContext context) => _open(context, 'tel:+60361964000');

  void _emailAdvisor(BuildContext context) {
    const advisorEmail = 'ahammad.ali@live.iium.edu.my';
    const matricNumber = '2319717';

    final subject = 'Academic Advising Session';

    final body =
        '''
Assalamualaikum,

I would like to request an academic advising session.

My matric number is $matricNumber.

Thank you.
''';

    final emailUri = Uri(
      scheme: 'mailto',
      path: advisorEmail,
      query:
          'subject=${Uri.encodeComponent(subject)}'
          '&body=${Uri.encodeComponent(body)}',
    );

    _open(context, emailUri.toString());
  }

  void _openMap(BuildContext context) => _open(
    context,
    Platform
            .isAndroid // ‹ NEW
        ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
              '&ll=3.0717,101.7182',
  );
  void _share(BuildContext context) => SharePlus.instance.share(
    ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            title: const Text('Open in-app'),
            subtitle: const Text('Open websites inside Campus Buddy KICT'),
            secondary: const Icon(Icons.open_in_browser),
            value: _openInApp,
            onChanged: (value) {
              setState(() {
                _openInApp = value;
              });
            },
          ),

          const Divider(),

          ..._links.map(
            (l) => Card(
              child: ListTile(
                leading: Icon(l.icon),
                title: Text(l.title),
                subtitle: Text(l.subtitle),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _open(context, l.uri),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap(context),
          ),

          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Kuantan campus map'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
            onTap: () => _open(
              context,
              'https://www.google.com/maps/search/?api=1'
              '&query=IIUM+Kuantan+Campus',
            ),
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: () => _callHotline(context),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text('Prefilled subject & body'),
            onTap: () => _emailAdvisor(context),
          ),
          const Divider(),
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
