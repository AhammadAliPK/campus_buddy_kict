import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';

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
    // ← NEW (homework 1): one line of data, zero new code
    'CELPAD',
    'Centre for Languages & Pre-University',
    Icons.translate,
    'https://www.iium.edu.my/celpad',
  ),
];

// ← NEW (homework 3): your own advisor + matric number
const _advisorEmail = 'advisor@iium.edu.my'; // TODO: your programme advisor
const _matricNo = 'BP321456';

/// Shares the app. Used by this page and by Home's AppBar (Step 9).
void shareApp() => SharePlus.instance.share(
  ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
);

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _inApp = false; // ← NEW (homework 2): just screen state

  Future<void> _open(String uri, {bool inApp = false}) async {
    final ok = await LinkOpener.open(uri, inApp: inApp);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline() => _open('tel:+60361964000');

  void _emailAdvisor() {
    // Uri.encodeComponent does the URL-encoding: space → %20, comma → %2C
    final subject = Uri.encodeComponent('Advising session');
    final body = Uri.encodeComponent(
      'Assalamualaikum, I would like to book an advising slot. '
      'Matric no: $_matricNo.',
    );
    _open('mailto:$_advisorEmail?subject=$subject&body=$body');
  }

  void _openMap(String name, String latLng) {
    final q = name.replaceAll(' ', '+');
    _open(
      Platform.isAndroid
          ? 'geo:$latLng?q=$q'
          : 'https://maps.apple.com/?q=$q&ll=$latLng',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            // ← NEW (homework 2)
            secondary: const Icon(Icons.open_in_browser),
            title: const Text('Open in-app'),
            subtitle: Text(
              _inApp
                  ? 'Websites open inside the app'
                  : 'Websites open in the browser',
            ),
            value: _inApp,
            onChanged: (v) => setState(() => _inApp = v),
          ),
          ..._links.map(
            (l) => Card(
              child: ListTile(
                leading: Icon(l.icon),
                title: Text(l.title),
                subtitle: Text(l.subtitle),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _open(l.uri, inApp: _inApp),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map — Gombak'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap('IIUM Gombak Campus', '3.0717,101.7182'),
          ),
          ListTile(
            // ← NEW (homework 1)
            leading: const Icon(Icons.map_outlined),
            title: const Text('Campus map — Kuantan'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
            onTap: () => _openMap('IIUM Kuantan Campus', '3.8462,103.3057'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: _callHotline,
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text('Prefilled subject & body with matric no.'),
            onTap: _emailAdvisor,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.share),
            title: Text('Share Campus Buddy KICT'),
            onTap: shareApp,
          ),
        ],
      ),
    );
  }
}
