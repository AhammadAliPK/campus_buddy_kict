import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Week 6 exercise: Home can ask, but it cannot clear the stars itself.
  // The favourites live inside the Courses screen's State, which Home can't reach
  // (see docs/week6_exercise.md). The working button is on the Courses tab.
  Future<void> _clearFavourites(BuildContext context) async {
    final sure = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
          title: 'Clear favourites',
          message: 'Are you sure? Every starred course loses its star.',
        ),
      ),
    );
    if (sure == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Home cannot reach the Courses list. Use the ☆ button on the Courses tab.',
          ),
        ),
      );
    }
  }

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
                MaterialPageRoute(builder: (_) => const PrayerScreen()),
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
                MaterialPageRoute(builder: (_) => const LinksScreen()),
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
          Card(
            child: ListTile(
              leading: const Icon(Icons.star_half),
              title: const Text('Clear all favourites'),
              subtitle: const Text('Asks first on its own screen'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearFavourites(context),
            ),
          ),
        ],
      ),
    );
  }
}
