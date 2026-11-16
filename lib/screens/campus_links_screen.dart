import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';

class LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;

  const LinkItem(
    this.title,
    this.subtitle,
    this.icon,
    this.uri
  );
}

const _links = [
  LinkItem(
    'IIUM portal',
    'Student porta & registration',
    Icons.school,
    'https://my.iium.edu.my',
  ),
  LinkItem(
    'IIUM website',
    'News & announcments',
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
];

class CampusLinksScreen extends StatelessWidget {
  const CampusLinksScreen({super.key});

  Future<void> _open(BuildContext context, String uri) async {
    final ok = await LinkOpener.open(uri);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Canot open $uri on this device'),
        ),
      );
    }
  }

  Future<void> _openMap(BuildContext context) async {
    final uri = Platform.isAndroid 
      ? 'geo:0,0?q=IIUM+Gombak+Campus'
      : 'https://maps.apple.com/?q=IIUM+Gombak+Campus';
    
    await _open(context, uri);
  }

  Future<void> _callHotline(BuildContext context) async {
    await _open(context, 'tel:+60361964000');
  }

  Future<void> _emailAdvisor(BuildContext context) async {
    // Lab placeholder
    final subject = Uri.encodeComponent('Advising session');
    final body = Uri.encodeComponent(
      'Assalamualaikum, I would like to book a slot.',
    );

    await _open(
      context,
      'mailto:advisor@iium.edu.my?subject=$subject&body=$body',
    );
  }

  Future<void> _share(BuildContext context) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Campus Buddy KICT - built in CSCI 4311 at IIUM.',
        ),
      );
    } catch (e) {
      debugPrint('Could not open sharing: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot open sharing on this device'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Links')
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ..._links.map(
            (link) => Card(
              child: ListTile(
                leading:Icon(link.icon),
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
            subtitle: const Text('Find IIUM Gombak Campus'),
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