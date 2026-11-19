import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Exercise: a whole confirmation screen that answers true / false.
  // Home can ask the question, but it cannot clear anything: the favourites
  // live inside _CoursesScreenState, and Home has no way to reach that State.
  // (Fix = state management: keep the course list above both screens.)
  Future<void> _clearFavourites(BuildContext context) async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          question: 'Clear all favourites?',
        ),
      ),
    );
    if (yes != true || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Home can't reach the favourites. Use the button on the Courses tab.",
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
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Campus Buddy KICT',
            onPressed: () => SharePlus.instance.share(ShareParams(
                text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.')),
          ),
          // Step 8: info icon opens About by name
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      // Step 9-10: Home is a menu of cards, and every card goes somewhere
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
              subtitle: const Text('Websites, map, call, email, share'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
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
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.star_outline),
            label: const Text('Clear all favourites'),
            onPressed: () => _clearFavourites(context),
          ),
        ],
      ),
    );
  }
}
