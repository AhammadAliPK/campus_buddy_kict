import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_clear_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus links'),
              subtitle: const Text('Arrives in Week 7'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CampusLinksScreen()),
              ),
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
          const SizedBox(height: 16),
          // Exercise in class: "clear all favourites" button on Home
          Card(
            child: ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Clear all favourites'),
              subtitle: const Text('State management demo'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final confirmed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConfirmClearScreen(
                      title: 'Clear All Favourites',
                      message:
                          'Are you sure you want to clear favourites from Home?',
                    ),
                  ),
                );
                if (confirmed == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cannot clear favourites from Home: favourites live inside the Courses screen and Home cannot reach them without state management. Use the Courses tab instead.',
                      ),
                      duration: Duration(seconds: 4),
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
