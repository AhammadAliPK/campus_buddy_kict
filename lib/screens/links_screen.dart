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
  LinkItem('IIUM portal', 'Student portal & registration', Icons.school,
      'https://my.iium.edu.my'),
  LinkItem('IIUM website', 'News & announcements', Icons.public,
      'https://www.iium.edu.my'),
  LinkItem('Library', 'Find books & e-resources', Icons.local_library,
      'https://division.iium.edu.my/lib'),
  LinkItem('KICT', 'Kuliyyah of ICT', Icons.computer,
      'https://www.iium.edu.my/kict'),
  // Homework: CELPAD link.
  LinkItem('CELPAD', 'Centre for Languages & Pre-University Academic Development',
      Icons.translate, 'https://celpad.iium.edu.my'),
];

// Homework: change to your real advisor's address.
const _advisorEmail = 'advisor@iium.edu.my';
const _matric = '2315568';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _inApp = false; // Homework: "Open in-app" switch (screen state only)

  Future<void> _open(String uri, {bool web = false}) async {
    final ok = await LinkOpener.open(
      uri,
      mode: web && _inApp
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

  void _emailAdvisor() {
    // Uri builds the query safely, so spaces/commas are encoded for us.
    final uri = Uri(
      scheme: 'mailto',
      path: _advisorEmail,
      query: 'subject=${Uri.encodeComponent('Advising session')}'
          '&body=${Uri.encodeComponent('Assalamualaikum, I would like to book a slot. My matric number is $_matric.')}',
    );
    _open(uri.toString());
  }

  void _openMap(String label, double lat, double lng) {
    final q = Uri.encodeQueryComponent(label);
    _open(Platform.isAndroid
        ? 'geo:$lat,$lng?q=$q'
        : 'https://maps.apple.com/?q=$q&ll=$lat,$lng');
  }

  void _share() => SharePlus.instance.share(
      ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.web),
            title: const Text('Open in-app'),
            subtitle: const Text('Websites open inside Campus Buddy KICT'),
            value: _inApp,
            onChanged: (v) => setState(() => _inApp = v),
          ),
          const Divider(),
          ..._links.map((l) => Card(
                child: ListTile(
                  leading: Icon(l.icon),
                  title: Text(l.title),
                  subtitle: Text(l.subtitle),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _open(l.uri, web: true),
                ),
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map — Gombak'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap('IIUM Gombak Campus', 3.0717, 101.7182),
          ),
          // Homework: Kuantan campus (approximate coordinates).
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Campus map — Kuantan'),
            subtitle: const Text('IIUM Kuantan Campus'),
            onTap: () => _openMap('IIUM Kuantan Campus', 3.8167, 103.3333),
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
            subtitle: const Text('Prefilled subject & body'),
            onTap: _emailAdvisor,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            onTap: _share,
          ),
        ],
      ),
    );
  }
}
