
import 'package:flutter/material.dart';
import 'placeholder_screen.dart';
import 'clear_favourites_screen.dart';

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
  
          // Prayer Times Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.wb_twilight),
              title: const Text('Prayer Times'),
              subtitle: const Text('Arrives in Week 8'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlaceholderScreen(
                      title: 'Prayer Times',
                      message: 'Coming in Week 8',
                      icon: Icons.mosque,
                    ),
                  ),
                );
              },
            ),
          ),

          // Campus Links Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Campus Links'),
              subtitle: const Text('Arrives in Week 7'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlaceholderScreen(
                      title: 'Campus Links',
                      message: 'Coming in Week 7',
                      icon: Icons.link,
                    ),
                  ),
                );
              },
            ),
          ),
 
          // About Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Campus Buddy KICT'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ),

          // Clear All Favourites Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Clear All Favourites'),
              subtitle: const Text('Manage your favourite courses'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final confirmed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ClearFavouritesScreen(),
                  ),
                );

                if (!context.mounted) return;

                if (confirmed == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'To clear favourites, use the Courses tab.',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
