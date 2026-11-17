
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(
            tooltip: 'Share app',
            icon: const Icon(Icons.share),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
                ),
              );
            },
          ),

          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Welcome to Campus Buddy!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Your campus companion at KICT.',
          ),

          const SizedBox(height: 24),

          // Prayer Times
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.access_time,
                size: 32,
              ),
              title: const Text('Prayer Times'),
              subtitle: const Text(
                'Prayer times feature coming in Week 8',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrayerTimesScreen(),
                  ),
                );
              },
            ),
          ),

          // Campus Links
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.link,
                size: 32,
              ),
              title: const Text('Campus Links'),
              subtitle: const Text(
                'Websites, map, call, email and share',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LinksScreen(),
                  ),
                );
              },
            ),
          ),

          // About
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.info,
                size: 32,
              ),
              title: const Text('About'),
              subtitle: const Text(
                'Learn about this application',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ),
        ],
      ),
    );
  }
}
