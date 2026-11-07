import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:campus_buddy_kict/screens/placeholder_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Exercise: Home can open the confirmation screen and get true/false back,
  // but it cannot clear anything. The favourites live inside
  // _CoursesScreenState (private state of another widget); Home is a sibling
  // tab, has no reference to that State, and a widget can only change its own
  // state with setState. Data that several screens need must live above
  // them, which is what state management (Provider/Riverpod, etc.) solves.
  Future<void> _clearFavourites(BuildContext context) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmScreen(
            message: 'This will clear all your favourite courses.'),
      ),
    );
    if (ok != true || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          "Home can't reach the favourites (they live inside the Courses "
          'screen). Use the Courses tab instead.'),
    ));
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
              subtitle: const Text('Arrives in Week 8'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PlaceholderScreen(
                      title: 'Prayer times', note: 'Coming in Week 8'),
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
                      title: 'Campus links', note: 'Coming in Week 7'),
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
          const SizedBox(height: 8),
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
