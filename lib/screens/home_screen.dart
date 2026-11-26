import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:campus_buddy_kict/screens/prayer_screen.dart';

class HomeScreen extends StatelessWidget {
 const HomeScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => SharePlus.instance.share(
                ShareParams(text: 'Campus Buddy KICT built in CSCI 4311 at IIUM.')),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'), // Opens the named route
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
              subtitle: const Text('Today in Kuala Lumpur'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async { 
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => PrayerScreen()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text('Campus links'),
              subtitle: Text('Websites, map, call, email, share'), // ← NEW
              trailing: Icon(Icons.chevron_right),
              onTap: () async { // ← NEW
                await Navigator.push<bool>( // ← NEW
                  context, // ← NEW
                  MaterialPageRoute(builder: (_) => LinksScreen()), // ← NEW
                ); // ← NEW
              }, // ← NEW
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Campus Buddy KICT'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/about'), // Uses the named route
            ),
          ),
        ],   
      ),
    );
  }
}
