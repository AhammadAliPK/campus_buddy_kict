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
  // Homework 1: CELPAD on the IIUM site.
  LinkItem(
    'CELPAD',
    'Centre for Languages & Pre-University Academic Development',
    Icons.translate,
    'https://www.iium.edu.my/division/celpad',
  ),
];

const shareText = 'Campus Buddy KICT — built in CSCI 4311 at IIUM.';

/// Shared by Home and the links page, so both share the same text.
void shareApp() => SharePlus.instance.share(ShareParams(text: shareText));

// Homework 3: my matric number in the mail body, URL-encoded
// (%20 = space, %2C = comma, %2E = full stop).
const advisorEmail =
    'ahammad.ali@live.iium.edu.my';
const advisorMailUri =
    'mailto:$advisorEmail?subject=Advising%20session'
    '&body=Assalamualaikum%2C%20I%20am%20Muhammad%20Zulnazmi%20Rafiqi%20'
    '(matric%202311687)%2C%20BCS%20Level%204%2E%20I%20would%20like%20to%20'
    'book%20an%20advising%20slot%2E';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _inApp = false; // Homework 2: just screen state, nothing saved yet.

  Future<void> _open(String uri, {bool website = false}) async {
    final ok = await LinkOpener.open(
      uri,
      mode: website && _inApp
          ? LaunchMode.inAppBrowserView
          : LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline() => _open('tel:+60361964000');

  void _emailAdvisor() => _open(advisorMailUri);

  // geo: is Android-only; iOS gets an Apple Maps https link.
  void _openGombakMap() => _open(
    Platform.isAndroid
        ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
              '&ll=3.0717,101.7182',
  );

  // Homework 1: Kuantan campus (Jalan Sultan Ahmad Shah, Bandar Indera Mahkota).
  void _openKuantanMap() => _open(
    Platform.isAndroid
        ? 'geo:3.8437,103.2972?q=IIUM+Kuantan+Campus'
        : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus'
              '&ll=3.8437,103.2972',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.open_in_browser),
            title: const Text('Open in-app'),
            subtitle: Text(
              _inApp
                  ? 'Websites open inside Campus Buddy'
                  : 'Websites open in your browser',
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
                onTap: () => _open(l.uri, website: true),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map: Gombak'),
            subtitle: const Text('IIUM Gombak on the maps app'),
            onTap: _openGombakMap,
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Campus map: Kuantan'),
            subtitle: const Text('IIUM Kuantan on the maps app'),
            onTap: _openKuantanMap,
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
            subtitle: const Text('Prefilled subject & body with my matric'),
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
