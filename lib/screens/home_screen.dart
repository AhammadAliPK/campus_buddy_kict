import 'package:campus_buddy_kict/screens/campus_links.dart';
import 'package:campus_buddy_kict/screens/notes_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/clear_favourite.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _confirmClearFavourites(BuildContext context) async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ClearFavouritesConfirmScreen()),
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Home cannot clear favourites. Please use the Courses tab.',
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
            icon: const Icon(Icons.share),
            tooltip: 'Share Campus Buddy KICT',
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(text: 'Campus Buddy KICT - built in CSCI 4311'),
              );
            },
          ),
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
              leading: Icon(Icons.wb_twighlight),
              title: Text('Prayer times'),
              subtitle: Text('Arrives in Week 8'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrayerTimes()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text('Campus links'),
              subtitle: Text('Websites, map, call, email, share'),
              trailing: Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => LinksScreen()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Campus Buddy KICT'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text('Notes'),
              subtitle: Text('Arrives in Week 11'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotesScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
