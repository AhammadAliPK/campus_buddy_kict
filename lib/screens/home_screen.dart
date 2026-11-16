import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
       actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(text: 'Check out Campus Buddy KICT!'),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.wb_twilight),
              title: const Text('Prayer times'),
              subtitle: const Text('Arrives in Week 8'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text('Campus links'),
              subtitle: Text('Websites, map, call, email, share'), // ← NEW
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                // ← NEW
                await Navigator.push<bool>(
                  // ← NEW
                  context, // ← NEW
                  MaterialPageRoute(builder: (_) => LinksScreen()), // ← NEW
                ); // ← NEW
              }, // ← NEW
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Campus Buddy KICT'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: const Center(child: Text('Coming in Week 8')),
    );
  }
}

class CampusLinksScreen extends StatelessWidget {
  const CampusLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Links')),
      body: const Center(child: Text('Coming in Week 7')),
    );
  }
}
