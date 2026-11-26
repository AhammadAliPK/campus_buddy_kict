import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class CampusLinksScreen extends StatelessWidget {
  const CampusLinksScreen({super.key});

  Future<void> _launch(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open ${uri.scheme}')),
        );
      }
    } catch (e) {
      debugPrint('Launch error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action not supported on this device')),
        );
      }
    }
  }

  Uri _getMapUri() {
    // geo: is Android-only; Web/iOS use https URLs
    if (!kIsWeb && Platform.isAndroid) {
      return Uri.parse('geo:3.2505,101.7346?q=KICT+IIUM+Gombak');
    }
    return Uri.parse('https://maps.google.com/?q=KICT+IIUM+Gombak');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Links'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share App',
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: 'Check out Campus Buddy KICT — my CSCI 4311 project!',
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('iTa\'LeEM Portal'),
              subtitle: const Text('https://italeemc.iium.edu.my'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launch(
                context,
                Uri.parse('https://italeemc.iium.edu.my'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.school),
              title: const Text('MyIIUM Portal'),
              subtitle: const Text('https://my.iium.edu.my'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launch(
                context,
                Uri.parse('https://my.iium.edu.my'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('KICT Location Map'),
              subtitle: const Text('IIUM Gombak Campus'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _launch(context, _getMapUri()),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Call KICT General Office'),
              subtitle: const Text('+603-6421 5601'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _launch(
                context,
                Uri(scheme: 'tel', path: '+60364215601'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email Academic Advisor'),
              subtitle: const Text('kict@iium.edu.my'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _launch(
                context,
                Uri(
                  scheme: 'mailto',
                  path: 'kict@iium.edu.my',
                  query: 'subject=Academic Advising Inquiry',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}