import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_stub_screen.dart';
import 'package:campus_buddy_kict/screens/links_stub_screen.dart';
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
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.wb_twilight),
            title: const Text('Prayer times'),
            subtitle: const Text('Arrives in Week 8'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrayerStubScreen()),
            ),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Campus links'),
            subtitle: const Text('Arrives in Week 7'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LinksStubScreen()),
            ),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Campus Buddy KICT'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/about'),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Clear all favourites'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final yes = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const ConfirmClearScreen()),
              );
              if (yes == true) {
                // Hand-in: can't actually clear from here. Favourites live
                // as local State (_courses) inside CoursesScreen. HomeScreen
                // is a sibling tab in the IndexedStack, not its parent, so
                // constructor args can't reach down and pop answers only go
                // back to the pusher. Fix concept: shared state management
                // (lift the list above both tabs).
              }
            },
          )),
        ],
      ),
    );
  }
}
