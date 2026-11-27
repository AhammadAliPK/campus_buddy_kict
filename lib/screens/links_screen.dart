import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkItem {
  final String title, subtitle;
  final IconData icon;
  final String uri;
  const LinkItem(
    this.title,
    this.subtitle,
    this.icon,
    this.uri,
  );
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
    'Centre for Languages and Pre-University Academic Development',
    Icons.language,
    'https://www.iium.edu.my/celpad/',
  )
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
bool _openInApp = false;

  Future<void> _open(BuildContext context, String uri) async {
  final scheme = Uri.parse(uri).scheme;
  final isWebsite = scheme == 'https' || scheme == 'http';

  final ok = await LinkOpener.open(
    uri,
    mode: _openInApp && isWebsite
        ? LaunchMode.inAppBrowserView
        : LaunchMode.externalApplication,
  );

  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cannot open $uri on this device')),
    );
  }
}

  void _callHotline(BuildContext context) =>
      _open(context, 'tel:+60361964000');

  void _emailAdvisor(BuildContext context) => _open(
        context,
        'mailto:aliahammadpk@gmail.com?subject=Advising%20session'
        '&body=Assalamualaikum%2C%20my%20name%20is%20Izzat.'
        '%20My%20matric%20number%20is%202312511.'
        '%20I%20would%20like%20to%20book%20an%20advising%20slot.',
      );
  void _openMap(BuildContext context) => _open(
        context,
        Platform.isAndroid
            ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
            : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
                '&ll=3.0717,101.7182',
      );

  void _share(BuildContext context) => SharePlus.instance.share(
        ShareParams(
          text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
        ),
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
          subtitle: const Text('Open websites inside the app'),
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
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Kuantan campus map'),
            subtitle: const Text('IIUM Kuantan, Indera Mahkota'),
            onTap: () => _open(context,
            Platform.isAndroid
                ? 'geo:3.843463462033142,103.30361028014141'
                  '?q=3.843463462033142,103.30361028014141(IIUM%20Kuantan)'
                : 'https://maps.apple.com/'
                  '?q=IIUM%20Kuantan'
                  '&ll=3.843463462033142,103.30361028014141',
            ),
          ),
        ],
      ),
    );
  }
}
