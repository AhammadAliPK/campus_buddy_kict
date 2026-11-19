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
  LinkItem('IIUM portal', 'Student portal & registration',
      Icons.school, 'https://my.iium.edu.my'),
  LinkItem('IIUM website', 'News & announcements',
      Icons.public, 'https://www.iium.edu.my'),
  LinkItem('Library', 'Find books & e-resources',
      Icons.local_library, 'https://division.iium.edu.my/lib'),
  LinkItem('KICT', 'Kuliyyah of ICT',
      Icons.computer, 'https://www.iium.edu.my/kict'),
  // Homework 1b: CELPAD
  LinkItem('CELPAD', 'Centre for Languages & Pre-University Academic Dev.',
      Icons.translate, 'https://centre.iium.edu.my/celpad/'),
];

// Homework 3: advisor and matric number for the mail link
const _advisorName = 'Poyilikandiyil Ahammad Ali';
const _advisorEmail = 'ahammad.ali@live.iium.edu.my';
const _matricNo = '2310077';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  // Homework 2: the switch is just screen state, nothing saved yet
  bool _openInApp = false;

  // [web] true only for https links, because the switch only affects websites.
  // tel:, mailto: and geo: always go to their own app.
  Future<void> _open(String uri, {bool web = false}) async {
    final ok = await LinkOpener.open(uri, inApp: web && _openInApp);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline() => _open('tel:+60361964000');

  // Homework 3: personal advisor + matric number in the body.
  // Uri.encodeComponent turns spaces into %20 and commas into %2C.
  void _emailAdvisor() {
    final subject = Uri.encodeComponent('Advising session');
    final body = Uri.encodeComponent(
        'Assalamualaikum $_advisorName, I would like to book a slot. '
        'My matric number is $_matricNo.');
    _open('mailto:$_advisorEmail?subject=$subject&body=$body');
  }

  // Homework 1a: one helper for every campus map entry.
  // geo: is Android-only, so iOS gets an Apple Maps https link.
  void _openMap(double lat, double lng, String name) {
    final q = Uri.encodeQueryComponent(name);
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
            secondary: const Icon(Icons.tab),
            title: const Text('Open in-app'),
            subtitle: const Text('Websites open inside Campus Buddy'),
            value: _openInApp,
            onChanged: (v) => setState(() => _openInApp = v),
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
            title: const Text('Campus map: Gombak'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap(3.0717, 101.7182, 'IIUM Gombak Campus'),
          ),
          // Homework 1a: Kuantan campus
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map: Kuantan'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
            onTap: () => _openMap(3.8462, 103.3057, 'IIUM Kuantan Campus'),
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