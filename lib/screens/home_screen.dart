
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/clear_favorites_screen.dart';

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
          Card(
            child: ListTile(
              leading: Icon(Icons.wb_twilight),
              title: Text('Prayer times'),
              subtitle: Text('Arrives in Week 8'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrayerTimesScreen(),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.link),
              title: Text('Campus links'),
              subtitle: Text('Arrives in Week 7'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CampusLinksScreen(),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Campus Buddy KICT'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.star_border),
            label: const Text('Clear all favourites'),
            onPressed: () async {
              final confirmed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClearFavoritesScreen(),
                ),
              );

              if (!context.mounted) return;

              if (confirmed == true) {
                // Cannot clear favourites from Home. The Home screen cannot clear the favourites
                // because the favourites are stored in the Courses screen's state. 
                //The Home screen cannot directly access or change the `_courses` list. 
                //This problem can be solved using **state management**, 
                //which allows different screens to share and update data. 
                //For now, the Clear All Favourites button works in the Courses screen 
                //because it can update its own state using `setState()`.
              }

            },
          ),

        ],
      ),

    );
  }
}
