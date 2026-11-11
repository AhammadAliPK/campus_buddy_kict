import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';                          // ← NEW
import 'package:campus_buddy_kict/screens/links_screen.dart';         // ← NEW

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'), // still const - fine
        actions: [                                                    // ← NEW
          IconButton(                                                 // ← NEW
            icon: const Icon(Icons.share),                            // ← NEW
            tooltip: 'Share Campus Buddy KICT',                       // ← NEW
            onPressed: () => SharePlus.instance.share(                // ← NEW
              ShareParams(                                            // ← NEW
                text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.', // ← NEW
              ),                                                      // ← NEW
            ),                                                        // ← NEW
          ),                                                          // ← NEW
        ],                                                            // ← NEW
      ),
      body: ListView(
        padding: const EdgeInsets.all(16), // still const - fine
        children: [ // ← NEW: the word `const` was DELETED here
          // ---- keep your other Week 6 cards here ----
          const Card(
            child: ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Prayer times'),
              subtitle: Text('Arrives in Week 8'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),

          // ---- the Campus links card, now working ----
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus links'),
              subtitle: const Text('Websites, map, call, email, share'), // ← NEW
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {                                       // ← NEW
                await Navigator.push<bool>(                           // ← NEW
                  context,                                            // ← NEW
                  MaterialPageRoute(builder: (_) => LinksScreen()),   // ← NEW
                );                                                    // ← NEW
              },                                                      // ← NEW
            ),
          ),
        ],
      ),
    );
  }
}