
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';

// Model for campus website links
class LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;

  const LinkItem(
      this.title,
      this.subtitle,
      this.icon,
      this.uri,
      );
}

// Campus website links
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
    'Centre for Languages and Pre-University Academic Development',
    Icons.language,
    'https://www.iium.edu.my/kulliyyah/celpad',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  // Controls whether website links open in-app
  bool _openInApp = false;

  // Open a URI using the selected launch mode
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

  // Open university hotline
  void _callHotline(BuildContext context) {
    _open(context, 'tel:+60361964000');
  }

  void _emailAdvisor(BuildContext context) {
    const advisorEmail = 'advisor@iium.edu.my';
    const matricNumber = '2316920';

    const subject = 'Academic Advising Session';

    const body = 'Assalamualaikum,\n\n'
        'I would like to request an academic advising session.\n\n'
        'My matric number is $matricNumber.\n\n'
        'Thank you.';

    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body);


    final emailUri =
        'mailto:$advisorEmail?subject=$encodedSubject&body=$encodedBody';

    _open(context, emailUri);
  }


  // Open IIUM Gombak campus map
  void _openMap(BuildContext context) {
    _open(
      context,
      Platform.isAndroid
          ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
          : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
          '&ll=3.0717,101.7182',
    );
  }

  // Open IIUM Kuantan campus map
  void _openKuantanMap(BuildContext context) {
    _open(
      context,
      Platform.isAndroid
          ? 'geo:3.84618,103.30821?q=IIUM+Kuantan+Campus'
          : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus'
          '&ll=3.84618,103.30821',
    );
  }

  // Share Campus Buddy KICT
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
          // Week 7: Open in-app switch
          SwitchListTile(
            secondary: const Icon(Icons.open_in_browser),
            title: const Text('Open in-app'),
            subtitle: const Text(
              'Open website links inside Campus Buddy KICT',
            ),
            value: _openInApp,
            onChanged: (value) {
              setState(() {
                _openInApp = value;
              });
            },
          ),

          const Divider(),

          // IIUM website links
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

          // IIUM Gombak campus map
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap(context),
          ),

          // IIUM Kuantan campus map
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('IIUM Kuantan Campus'),
            subtitle: const Text('Open Kuantan campus map'),
            onTap: () => _openKuantanMap(context),
          ),

          // University hotline
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: () => _callHotline(context),
          ),

          // Academic advisor email
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text(
              'Prefilled subject, message & matric number',
            ),
            onTap: () => _emailAdvisor(context),
          ),

          const Divider(),

          // Share Campus Buddy KICT
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
