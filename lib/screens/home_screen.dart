import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Exercise: Home can ask the question, but it cannot clear anything.
  // The favourites live in _courses, which is private state inside
  // _CoursesScreenState. Home is a separate widget in the IndexedStack,
  // so it has no reference to that list and no way to call its setState.
  // Sharing data between screens like this needs state management
  // (keeping the data above both screens so either one can change it).
  Future<void> _clearFavourites(BuildContext context) async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          message: 'This removes the star from every course.',
        ),
      ),
    );
    if (yes != true || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Home can't reach the Courses list — use the button on the Courses tab",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          const IconButton(
            // ← NEW (Week 7 Step 9): same helper as the links page
            icon: Icon(Icons.share),
            tooltip: 'Share',
            onPressed: shareApp,
          ),
          IconButton(
            // ← NEW (Step 8)
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: ListView(
        // ← CHANGED (Step 9 + 10): a menu of cards
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
              subtitle: const Text(
                'Websites, map, call, email, share',
              ), // ← NEW
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // ← NEW (Step 7)
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const LinksScreen()),
                );
              },
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
          Card(
            // ← NEW (exercise)
            child: ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Clear all favourites'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearFavourites(context),
            ),
          ),
        ],
      ),
    );
  }
}
