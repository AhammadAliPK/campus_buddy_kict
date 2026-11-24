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
    'Centre for Languages and Pre-University Academic Development',
    Icons.language,
    'https://celpad.iium.edu.my',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  Future<void> _openInApp(BuildContext context, String uri) async {
    final url = Uri.parse(uri);

    final ok = await launchUrl(url, mode: LaunchMode.inAppBrowserView);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot open $uri on the device')));
    }
  }

  Future<void> _openExternal(BuildContext context, String uri) async {
    final url = Uri.parse(uri);

    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot open $uri on the device')));
    }
  }

  void _callHotline(BuildContext context) =>
      _openExternal(context, 'tel:60361964000');

  void _emailAdvisor(BuildContext context) {
    const advisorEmail = 'YOUR_ADVISOR_EMAIL';
    const matricNumber = '2313190';

    final emailUri = Uri(
      scheme: 'mailto',
      path: advisorEmail,
      queryParameters: {'body': 'Matric no: $matricNumber'},
    );

    _openExternal(context, emailUri.toString());
  }

  /*void _openMap(BuildContext context) => _open(
    context,
    Platform
            .isAndroid // ← NEW
        ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
              '&ll=3.0717,101.7182',
  ); */

  void _openMap(BuildContext context) => _openExternal(
    context,
    Platform
            .isAndroid // ← NEW
        ? 'geo:3.8433,101.3037?q=IIUM+Kuantan+Campus'
        : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus'
              '&ll=3.8433,101.3037',
  );

  void _share(BuildContext context) => SharePlus.instance.share(
    ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Links')),
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
                onTap: () => _openInApp(context, l.uri),
              ),
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
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
        ],
      ),
    );
  }
}
