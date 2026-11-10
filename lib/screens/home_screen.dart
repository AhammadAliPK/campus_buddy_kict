import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:share_plus/share_plus.dart'; 

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
            onPressed: () {
              // Week 7: Share button
              SharePlus.instance.share(ShareParams(text: 'Campus Buddy KICT - built in CSCI 4311 at IIUM.'));
            }, 
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. PRAYER TIMES (Placeholder for Week 8)
          Card(
            child: ListTile(
              leading: const Icon(Icons.wb_twilight),
              title: const Text('Prayer times'),
              subtitle: const Text('Arrives in Week 8'), // 👈 Fixed
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming in Week 8')),
                );
              },
            ),
          ),
          
          // 2. CAMPUS LINKS (Goes to LinksScreen)
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus links'),
              subtitle: const Text('Websites, map, call, email, share'), // 👈 Fixed
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push( // 👈 Fixed
                  context,
                  MaterialPageRoute(builder: (_) => const LinksScreen()),
                );
              },
            ),
          ),
          
          // 3. ABOUT
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Campus Buddy KICT'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/about'), 
            ),
          ),
        ],
      ),
    );
  }
}