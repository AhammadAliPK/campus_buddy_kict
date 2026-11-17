import 'dart:io';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // Needed for LaunchMode

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
 LinkItem('CELPAD', 'Languages & Pre-U',
 Icons.language, 'https://www.iium.edu.my/celpad'),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  // State for the in-app browser switch
  bool _openInApp = false; 

  Future<void> _open(BuildContext context, String uri, {LaunchMode mode = LaunchMode.externalApplication}) async {
    final ok = await LinkOpener.open(uri, mode: mode);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open $uri on this device')),
      );
    }
  }

  void _callHotline(BuildContext context) =>
      _open(context, 'tel:+60361964000');

  // Personalized email with matric number URL-encoded
  void _emailAdvisor(BuildContext context) => _open(context,
      'mailto:advisor@iium.edu.my?subject=Advising%20session'
      '&body=Assalamualaikum%2C%20I%20would%20like%20to%20book%20a%20slot.%20My%20matric%20number%20is%202313387.');

  void _openGombakMap(BuildContext context) => _open(
      context,
      Platform.isAndroid
          ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
          : 'https://maps.apple.com/?q=IIUM+Gombak+Campus&ll=3.0717,101.7182');

  // Kuantan Campus map
  void _openKuantanMap(BuildContext context) => _open(
      context,
      Platform.isAndroid
          ? 'geo:3.8185,103.3283?q=IIUM+Kuantan+Campus'
          : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus&ll=3.8185,103.3283');

  void _share(BuildContext context) => SharePlus.instance.share(
      ShareParams(text: 'Campus Buddy KICT built in CSCI 4311 at IIUM.'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Switch to control browser behavior
          SwitchListTile(
            title: const Text('Open websites in-app'),
            subtitle: const Text('Keep links inside Campus Buddy'),
            value: _openInApp,
            onChanged: (val) => setState(() => _openInApp = val),
          ),
          const Divider(),
          ..._links.map((l) => Card(
                child: ListTile(
                  leading: Icon(l.icon),
                  title: Text(l.title),
                  subtitle: Text(l.subtitle),
                  trailing: const Icon(Icons.open_in_new),
                  // Passes inAppBrowserView if the switch is ON
                  onTap: () => _open(
                    context, 
                    l.uri, 
                    mode: _openInApp ? LaunchMode.inAppBrowserView : LaunchMode.externalApplication
                  ),
                ),
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('IIUM Gombak Campus map'),
            subtitle: const Text('Main Campus on Google Maps'),
            onTap: () => _openGombakMap(context),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('IIUM Kuantan Campus map'),
            subtitle: const Text('Medical Campus on Google Maps'),
            onTap: () => _openKuantanMap(context),
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
            subtitle: const Text('Prefilled with matric 2313387'),
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
