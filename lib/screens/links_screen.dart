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

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  static void share() => SharePlus.instance.share(
    ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'));

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

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

  static const _advisorEmail = 'siti_asma@iium.edu.my';
  static const _matricNo = '2317573';

  void _emailAdvisor(BuildContext context) {
    final subject = Uri.encodeComponent('Advising session');
    final body = Uri.encodeComponent(
      'Assalamualaikum Dr., I would like to book an advising slot.\n\n'
      'Matric no: $_matricNo');
    _open(context, 'mailto:$_advisorEmail?subject=$subject&body=$body');
  }

  void _openMap(BuildContext context, String latLng, String query) => _open(
    context,
    Platform.isAndroid
    ? 'geo:$latLng?q=$query'
    : 'https://maps.apple.com/?q=$query&ll=$latLng');

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
            subtitle: const Text('Show websites inside Campus Buddy'),
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
              onTap: () => _open(context, l.uri,
                mode: _openInApp
                  ? LaunchMode.inAppBrowserView
                  : LaunchMode.externalApplication),
            ),
          )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap(context, '3.0717,101.7182', 'IIUM+Gombak+Campus'),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Kuantan campus map'),
            subtitle: const Text('IIUM Kuantan (Indera Mahkota) on Google Maps'),
            onTap: () => _openMap(context, '3.8462,103.3057', 'IIUM+Kuantan+Campus'),
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
            subtitle: const Text(_advisorEmail),
            onTap: () => _emailAdvisor(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            onTap: LinksScreen.share,
          ),
        ],
      ),
    );
  }
}