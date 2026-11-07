import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/prayer_times_screen.dart';
import 'package:campus_buddy_kict/campus_links_screen.dart';
import 'package:campus_buddy_kict/confirm_screen.dart';

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
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.star_border),
            label: const Text('Clear all favourites'),
            onPressed: () async {
              final yes = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConfirmScreen(
                    message: 'Clear all favourite courses?',
                  ),
                ),
              );
              if (yes != true || !context.mounted) return;
              // Home can't actually touch the favourites (see week6_exercise.txt).
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Can't clear from Home — favourites live in the "
                    "Courses tab. Use the button there instead.",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
