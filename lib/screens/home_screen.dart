
import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favorites_screen.dart';
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
        // Week 7: Share button
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: 'Share Campus Buddy KICT',
          onPressed: () async {
            await SharePlus.instance.share(
              ShareParams(
                text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
              ),
            );
          },
        ),

          // Week 6: About button
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Prayer Times card
          Card(
            child: ListTile(
              leading: const Icon(Icons.wb_twilight),
              title: const Text('Prayer times'),
              subtitle: const Text('Arrives in Week 8'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PrayerTimesScreen(),
                  ),
                );
              },
            ),
          ),

          // Campus Links card
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus links'),
              subtitle: const Text(
                'Websites, map, call, email, share',
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

          // About card
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Campus Buddy KICT'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Clear all favourites'),
              subtitle: const Text('In-class exercise'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final confirmed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClearFavoritesScreen(),
                  ),
                );

                if (!context.mounted) return;

                if (confirmed == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Confirmed! Favourites are managed in Courses.',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
