import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(                                         // Step 8: ⓘ button
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'), // open by NAME
          ),
        ],
      ),
      body: ListView(                                         // Step 9: a menu of cards
        padding: const EdgeInsets.all(16),
        children: [                     // NOT const any more: the onTaps make it change
          Card(child: ListTile(
            leading: const Icon(Icons.wb_twilight),
            title: const Text('Prayer times'),
            subtitle: const Text('Arrives in Week 8'),
            trailing: const Icon(Icons.chevron_right),        // the ">" arrow = "opens something"
            onTap: () => Navigator.push(context,              // Step 10: open placeholder
                MaterialPageRoute(builder: (_) => const PrayerTimesScreen())),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Campus links'),
            subtitle: const Text('Arrives in Week 7'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CampusLinksScreen())),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Campus Buddy KICT'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/about'), // same page as the ⓘ
          )),
        ],
      ),
    );
  }
}