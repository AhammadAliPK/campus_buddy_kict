import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:campus_buddy_kict/services/app_share.dart';

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
  LinkItem('CELPAD', 'Languages & pre-university centre',
      Icons.translate, 'https://centre.iium.edu.my/celpad'),
];

// Assignment 5 — personal advising email.
const _advisorEmail = 'advisor@iium.edu.my'; // TODO: your programme advisor
const _matricNo = '2311252';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});
  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _inApp = false; // screen state only — nothing saved yet

  Future<void> _open(BuildContext context, String uri,
      {LaunchMode mode = LaunchMode.externalApplication}) async {
    final ok = await LinkOpener.open(uri, mode: mode);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline(BuildContext context) =>
      _open(context, 'tel:+60361964000');

  // Websites follow the switch; tel:/mailto:/geo: always use external apps.
  void _openWebsite(BuildContext context, String uri) => _open(context, uri,
      mode: _inApp
          ? LaunchMode.inAppBrowserView
          : LaunchMode.externalApplication);

  void _emailAdvisor(BuildContext context) {
    // encodeComponent turns spaces into %20, commas into %2C, etc.
    final subject = Uri.encodeComponent('Advising session');
    final body = Uri.encodeComponent(
        'Assalamualaikum, I am Sara Iman binti Azhar (matric no. $_matricNo). '
        'I would like to book an advising slot.');
    _open(context, 'mailto:$_advisorEmail?subject=$subject&body=$body');
  }

  void _openMap(BuildContext context,
          {required String label, required String latLng}) =>
      _open(
          context,
          Platform.isAndroid
              ? 'geo:$latLng?q=$label'
              : 'https://maps.apple.com/?q=$label&ll=$latLng');

  void _share(BuildContext context) => AppShare.share();

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
            subtitle: Text(_inApp
                ? 'Websites open inside Campus Buddy'
                : 'Websites open in your browser'),
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
                  onTap: () => _openWebsite(context, l.uri),
                ),
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak'),
            onTap: () => _openMap(context,
                label: 'IIUM+Gombak+Campus', latLng: '3.0717,101.7182'),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Kuantan campus map'),
            subtitle: const Text('IIUM Kuantan, Bandar Indera Mahkota'),
            onTap: () => _openMap(context,
                label: 'IIUM+Kuantan+Campus', latLng: '3.8462,103.3057'),
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
            subtitle: const Text('Prefilled with your matric number'),
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
