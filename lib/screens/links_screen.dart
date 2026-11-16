import 'dart:io';

import 'package:flutter/material.dart';
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
    'Centre for language & Pre-University Academic Development',
    Icons.language,
    'https://www.iium.edu.my/celpad',
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
    final parsedUri = Uri.parse(uri);

    final isWebsite = parsedUri.scheme == 'http' || parsedUri.scheme == 'https';

    final mode = isWebsite && _openInApp
        ? LaunchMode.inAppBrowserView
        : LaunchMode.externalApplication;

    final ok = await launchUrl(parsedUri, mode: mode);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline(BuildContext context) => _open(context, 'tel:+60361964000');
  void _emailAdvisor(BuildContext context) {

    final emailUri = Uri.parse(
      'mailto:nadhrah@iium.edu.my'
      '?subject=Advising%20session'
      '&body=Assalamualaikum%2C%0A%0A'
      'I%20would%20like%20to%20book%20an%20advising%20session.%0A%0A'
      'My%20matric%20number%20is%202318463.%0A%0A'
      'Thank%20you.',
    );

    _open(context, emailUri.toString());
  }

  void _openMapGombak(BuildContext context) => _open(
    context,
    Platform
            .isAndroid // ← NEW
        ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
              '&ll=3.0717,101.7182',
  );
  void _openMapKuantan(BuildContext context) => _open(
    context,
    Platform
            .isAndroid // ← NEW
        ? 'geo:3.8167,103.3333?q=IIUM+Kuantan+Campus'
        : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus'
              '&ll=3.8167,103.3333',
  );
  void _share(BuildContext context) => SharePlus.instance.share(
    ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus links'),
        actions: [
          const Text('Open in-app', style: TextStyle(fontSize: 12)),
          Switch(
            value: _openInApp,
            onChanged: (value) {
              setState(() {
                _openInApp = value;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
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
            onTap: () => _openMapGombak(context),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
            onTap: () => _openMapKuantan(context),
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
