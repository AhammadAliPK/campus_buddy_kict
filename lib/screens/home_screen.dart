import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';   // ← NEW
import 'package:campus_buddy_kict/screens/links_screen.dart';   // ← CHANGED: the real page
import 'package:share_plus/share_plus.dart';                    // ← NEW: for the share button  // ← NEW
import 'package:campus_buddy_kict/screens/confirm_screen.dart';   // ← NEW

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(                                         // ← NEW
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
          IconButton(                                         // ← NEW: Week 7 share
            icon: const Icon(Icons.share),
            onPressed: () => SharePlus.instance.share(
                ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.')),
          ),
        ],
      ),
      body: ListView(                                   // ← CHANGED: a menu of cards
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.wb_twilight),
            title: const Text('Prayer times'),
            subtitle: const Text('Arrives in Week 8'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PrayerTimesScreen())),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Campus links'),
            subtitle: const Text('Websites, map, call, email, share'),   // ← NEW
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {                                            // ← NEW
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const LinksScreen()),
              );
            },
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Campus Buddy KICT'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/about'),
          )),
          Card(child: ListTile(                              // ← NEW
            leading: const Icon(Icons.clear_all),
            title: const Text('Clear all favourites'),
            onTap: () async {
              final sure = await Navigator.push<bool>(context,
                  MaterialPageRoute(builder: (_) => const ConfirmScreen()));
              if (sure != true || !context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Can't clear from Home. Use the Courses tab."),
              ));
            },
          )),
        ],
      ),
    );
  }
}