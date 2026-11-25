import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;

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
    'Centre for Languages & Pre-University',
    Icons.translate,
    'https://www.iium.edu.my/administration/celpad/',
  ),
];

// Shared by Links and Home so the share text lives in one place.
void shareApp() => SharePlus.instance.share(
      ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
    );

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _inApp = false; // screen state only, not saved

  // ---------- Actions ----------

  Future<void> _open(
    BuildContext context,
    String uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final ok = await LinkOpener.open(uri, mode: mode);
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
        'mailto:zainab_senan@iium.edu.my'
        '?subject=${Uri.encodeComponent('Advising session')}'
        '&body=${Uri.encodeComponent('Assalamualaikum, I would like to book a slot. Matric no: 2317391')}',
      );

  void _openMap(BuildContext context, String latLng, String label) => _open(
        context,
        Platform.isAndroid
            ? 'geo:$latLng?q=${Uri.encodeComponent(label)}'
            : 'https://maps.apple.com/?q=${Uri.encodeComponent(label)}'
                '&ll=$latLng',
      );

  // ---------- UI ----------

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
            subtitle: const Text('Websites open inside the app'),
            value: _inApp,
            onChanged: (v) => setState(() => _inApp = v),
          ),

          // Web links
          ..._links.map(
            (l) => Card(
              child: ListTile(
                leading: Icon(l.icon),
                title: Text(l.title),
                subtitle: Text(l.subtitle),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _open(
                  context,
                  l.uri,
                  mode: _inApp
                      ? LaunchMode.inAppBrowserView
                      : LaunchMode.externalApplication,
                ),
              ),
            ),
          ),

          const Divider(),

          // Device intents
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () =>
                _openMap(context, '3.0717,101.7182', 'IIUM Gombak Campus'),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Kuantan campus map'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
            onTap: () =>
                _openMap(context, '3.843009,103.303954', 'IIUM Kuantan Campus'),
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

          // Share
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            onTap: shareApp,
          ),
        ],
      ),
    );
  }
}
