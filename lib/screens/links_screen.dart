
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Model for campus website links
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

// IIUM website links
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
    'Kulliyyah of ICT',
    Icons.computer,
    'https://www.iium.edu.my/kict',
  ),
  LinkItem(
    'CELPAD IIUM',
    'Centre for Languages and Pre-University Academic Development',
    Icons.language,
    'https://centre.iium.edu.my/celpad/',
  ),
];

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _openInApp = false;

  // Open websites, phone numbers and email links
  Future<void> _open(BuildContext context, String uri) async {
    final bool isWebsite =
        uri.startsWith('https://') || uri.startsWith('http://');

    final LaunchMode mode = isWebsite && _openInApp
        ? LaunchMode.inAppBrowserView
        : LaunchMode.externalApplication;

    final bool success = await LinkOpener.open(
      uri,
      mode: mode,
    );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open $uri on this device'),
        ),
      );
    }
  }

  // Call IIUM hotline
  void _callHotline(BuildContext context) {
    _open(context, 'tel:+60361964000');
  }

  // Email academic advisor with matric number
  void _emailAdvisor(BuildContext context) {
    // Replace this with your real advisor email later
    const String advisorEmail = 'kict_academic@iium.edu.my';

    final String subject = Uri.encodeComponent(
      'Academic Advising Session - 2312372',
    );

    final String body = Uri.encodeComponent(
      'Assalamualaikum,\n\n'
      'I would like to request an academic advising session.\n\n'
      'My matric number is 2312372.\n\n'
      'Thank you.',
    );

    _open(
      context,
      'mailto:$advisorEmail?subject=$subject&body=$body',
    );
  }

  // Open IIUM Gombak Campus in Google Maps
  void _openGombakMap(BuildContext context) {
    _open(
      context,
      'https://www.google.com/maps/search/?api=1'
      '&query=IIUM%20Gombak%20Campus',
    );
  }

  // Open IIUM Kuantan Campus in Google Maps
  void _openKuantanMap(BuildContext context) {
    _open(
      context,
      'https://www.google.com/maps/search/?api=1'
      '&query=IIUM%20Kuantan%20Campus',
    );
  }

  // Share Campus Buddy KICT
  Future<void> _share() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sharing is not available on this device'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus links'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Open in-app switch
          SwitchListTile(
            secondary: const Icon(Icons.open_in_browser),
            title: const Text('Open in-app'),
            subtitle: const Text(
              'Open websites inside Campus Buddy',
            ),
            value: _openInApp,
            onChanged: (value) {
              setState(() {
                _openInApp = value;
              });
            },
          ),

          const Divider(),

          // IIUM website links
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

          // IIUM Gombak Campus
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text(
              'IIUM Gombak on Google Maps',
            ),
            onTap: () => _openGombakMap(context),
          ),

          // IIUM Kuantan Campus
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('IIUM Kuantan Campus'),
            subtitle: const Text(
              'Open Kuantan Campus on Google Maps',
            ),
            onTap: () => _openKuantanMap(context),
          ),

          const Divider(),

          // University hotline
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: () => _callHotline(context),
          ),

          // Academic advisor email
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text(
              'Prefilled subject & matric number',
            ),
            onTap: () => _emailAdvisor(context),
          ),

          const Divider(),

          // Share application
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            subtitle: const Text(
              'Share this app with your friends',
            ),
            onTap: _share,
          ),
        ],
      ),
    );
  }
}
