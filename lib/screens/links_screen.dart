import 'dart:io' show Platform;

import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class LinkItem {
  const LinkItem(this.title, this.subtitle, this.icon, this.uri);

  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;
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
];

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  Future<void> _open(BuildContext context, String uri) async {
    final opened = await LinkOpener.open(uri);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline(BuildContext context) {
    _open(context, 'tel:+60361964000');
  }

  void _emailAdvisor(BuildContext context) {
    _open(
      context,
      'mailto:advisor@iium.edu.my?subject=Advising%20session'
      '&body=Assalamualaikum%2C%20I%20would%20like%20to%20book%20a%20slot.',
    );
  }

  void _openMap(BuildContext context) {
    final String uri;
    if (kIsWeb) {
      uri = 'https://www.google.com/maps/search/?api=1&query=IIUM+Gombak+Campus';
    } else if (Platform.isAndroid) {
      uri = 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus';
    } else {
      uri = 'https://maps.apple.com/?q=IIUM+Gombak+Campus&ll=3.0717,101.7182';
    }
    _open(context, uri);
  }

  Future<void> _share(BuildContext context) async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
      );
    } catch (error) {
      debugPrint('LinksScreen: could not share Campus Buddy KICT — $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the share sheet')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
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
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak Campus'),
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
        ],
      ),
    );
  }
}
