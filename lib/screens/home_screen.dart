import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/clear_favourites_screen.dart';
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
            tooltip: 'Share Campus Buddy KICT',
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.',
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlaceholderScreen(
                      title: 'Prayer times',
                      message: 'Coming in Week 8',
                    ),
                  ),
                );
              },
            ),
          ),
          // Card(
          //   child: ListTile(
          //     leading: const Icon(Icons.link),
          //     title: const Text('Campus links'),
          //     subtitle: const Text('Arrives in Week 7'),
          //     trailing: const Icon(Icons.chevron_right),
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => const PlaceholderScreen(
          //             title: 'Campus links',
          //             message: 'Coming in Week 7',
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus links'),
              subtitle: const Text('Websites, map, call, email, share'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const LinksScreen()),
                );
              },
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

          ElevatedButton(
            onPressed: () async {
              final confirmed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClearFavouritesScreen(),
                ),
              );

              if (!context.mounted) return;

              if (confirmed == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Confirmed! Favourites are not cleared yet.'),
                  ),
                );
              }
            },
            child: const Text('Clear All Favourites'),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(message)),
    );
  }
}

// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Campus Buddy KICT')),
//       body: const Center(child: Text('Home — coming in Week 7')),
//     );
//   }
// }
