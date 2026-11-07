import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_clear_screen.dart';   

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // NEW: opens the confirmation screen, but cannot clear anything
  Future<void> _clearFavourites(BuildContext context) async {
    final sure = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ConfirmClearScreen()),
    );
    if (sure != true || !context.mounted) return;

    // The answer is true, but the favourites live inside the Courses
    // screen's State. Home has no way to reach them.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Home can't reach the favourites. Use the Courses tab."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
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
              subtitle: const Text('prayer'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrayerTimesScreen(),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus links'),
              subtitle: const Text('Links'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CampusLinksScreen(),
                ),
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
          // NEW: the "clear all favourites" button
          FilledButton.tonalIcon(
            icon: const Icon(Icons.star_border),
            label: const Text('Clear all favourites'),
            onPressed: () => _clearFavourites(context),
          ),
        ],
      ),
    );
  }
}