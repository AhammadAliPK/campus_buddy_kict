
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:campus_buddy_kict/services/link_opener.dart';

class LinkItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String uri;

  const LinkItem(
    this.title,
    this.subtitle,
    this.icon,
    this.uri,
  );
}

// List of IIUM websites
const _links = [
  LinkItem(
    'IIUM Portal',
    'Student portal & registration',
    Icons.school,
    'https://my.iium.edu.my',
  ),
  LinkItem(
    'IIUM Website',
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
    'https://www.iium.edu.my/v2/celpad',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

  // Open website or external application
  Future<void> _open(
    String uri, {
    bool useInAppBrowser = false,
  }) async {
    final isWebsite = uri.startsWith('https://');

    final mode = useInAppBrowser && isWebsite
        ? LaunchMode.inAppBrowserView
        : LaunchMode.externalApplication;

    final ok = await LinkOpener.open(
      uri,
      mode: mode,
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open $uri on this device'),
        ),
      );
    }
  }

  // Call IIUM hotline
  Future<void> _callHotline() async {
    await _open('tel:+60361964000');
  }

  // Email academic advisor
  Future<void> _emailAdvisor() async {
    await _open(
      'mailto:advisor@iium.edu.my'
      '?subject=Advising%20session'
      '&body=Assalamualaikum%2C%20'
      'I%20would%20like%20to%20book%20a%20slot.%0A'
      'Matric%20Number%3A%202314323',
    );
  }

  // Open Gombak campus map
  Future<void> _openGombakMap() async {
    final mapUri = Platform.isAndroid
        ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'
        : 'https://maps.apple.com/?q=IIUM+Gombak+Campus'
            '&ll=3.0717,101.7182';

    await _open(mapUri);
  }

  // Open Kuantan campus map
  Future<void> _openKuantanMap() async {
    final mapUri = Platform.isAndroid
        ? 'geo:3.84085,103.30217?q=IIUM+Kuantan+Campus'
        : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus'
            '&ll=3.84085,103.30217';

    await _open(mapUri);
  }

  // Share application information
  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Links'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          // Open in-app browser switch
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.web),
              title: const Text('Open in-app browser'),
              subtitle: Text(
                _openInApp
                    ? 'Websites open inside the app'
                    : 'Websites open in an external browser',
              ),
              value: _openInApp,
              onChanged: (value) {
                setState(() {
                  _openInApp = value;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // IIUM website links
          ..._links.map(
            (link) => Card(
              child: ListTile(
                leading: Icon(link.icon),
                title: Text(link.title),
                subtitle: Text(link.subtitle),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _open(
                  link.uri,
                  useInAppBrowser: _openInApp,
                ),
              ),
            ),
          ),

          const Divider(),

          // Gombak Campus Map
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('IIUM Gombak Campus Map'),
            subtitle: const Text('Gombak, Selangor'),
            trailing: const Icon(Icons.location_on),
            onTap: _openGombakMap,
          ),

          // Kuantan Campus Map
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('IIUM Kuantan Campus Map'),
            subtitle: const Text(
              'Bandar Indera Mahkota, Kuantan',
            ),
            trailing: const Icon(Icons.location_on),
            onTap: _openKuantanMap,
          ),

          const Divider(),

          // University hotline
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call University Hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            trailing: const Icon(Icons.call),
            onTap: _callHotline,
          ),

          // Academic advisor email
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email Academic Advisor'),
            subtitle: const Text(
              'Includes matric number: 2314323',
            ),
            trailing: const Icon(Icons.email),
            onTap: _emailAdvisor,
          ),

          const Divider(),

          // Share application
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            subtitle: const Text('Share application information'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: _share,
          ),
        ],
      ),
    );
  }
}
