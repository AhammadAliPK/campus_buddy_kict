import 'package:campus_buddy_kict/screens/campus_links.dart';
import 'package:campus_buddy_kict/screens/notes_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times.dart';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/clear_favourite.dart';

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
            onPressed: () => _confirmClearFavourites(context),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear All Favourites',
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
              subtitle: Text('Arrives in Week 7'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CampusLinks()),
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
