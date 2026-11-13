import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:campus_buddy_kict/screens/placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Exercise: Home asks for confirmation, but cannot clear the favourites.
  Future<void> _clearFavourites(BuildContext context) async {
    final yes = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
            message: 'Clear all your starred courses?'),
      ),
    );
    if (yes == true && context.mounted) {
      // The favourites live inside the Courses screen's State, which Home
      // cannot reach: Home and Courses are siblings, and a State object is
      // private to its own widget. Nothing is passed between them, so there
      // is nothing for Home to modify. The fix is state management: keep the
      // courses list in one shared place above both tabs (the shell, or a
      // provider-style object) that either screen can read and change.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Home can\'t reach the favourites — '
              'use the Clear button on the Courses tab.'),
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
                MaterialPageRoute(
                  builder: (_) => const PlaceholderScreen(
                      title: 'Prayer times', note: 'Arrives in Week 8'),
                ),
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
                MaterialPageRoute(
                  builder: (_) => const PlaceholderScreen(
                      title: 'Campus links', note: 'Arrives in Week 7'),
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
          OutlinedButton.icon(
            icon: const Icon(Icons.star_border),
            label: const Text('Clear all favourites'),
            onPressed: () => _clearFavourites(context),
          ),
        ],
      ),
    );
  }
}
