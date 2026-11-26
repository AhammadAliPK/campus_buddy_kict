import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
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
              SharePlus.instance.share(
                ShareParams(
                  text: 'Campus Buddy KICT built in CSCI 4311 at IIUM.',
                ),
              );
            } 
          ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrayerTimesScreen(),
                  ),
                );
              },
            ),
          ),
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

         /*const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            icon: const Icon(Icons.star_border_clear),
            label: const Text('Clear All Favorites'),
            onPressed: () async {
              final confirmed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ConfirmClearFavoritesScreen(),
                ),
              );

              if (confirmed == true) {
                // cannot do anything here because _courses lives inside CoursesScreen
              }
              
            }, 
          ), */
        ],
      ),
    );
  }
}
      
/*
Why Home cannot clear the favourites:

We cannot clear the favourites from the Home Screen because the 
_courses list is private state stored inside CoursesScreen. Since 
HomeScreen and CoursesScreen are separate sibling screens, Home 
doesn't have direct access to modify _courses or trigger setState on
it. Normal StatefulWidget state can't pass data across different screen 
trees like this. To solve this problem and share app state across screens, 
we need to use state management
*/

/* 
In-Class Exercise Answers (Malfunction Report)

1. Observations
- Website links: Tapping them opens the web browser, but the browser displays "Looks like you're 
                not connected to a network. Check your settings and try again" page.
- Map, Dialer, Mail: The phone dialer opens with +60361964000 pre-filled, and the email app opens
  with the subject/body pre-filled. The map app opens but fails to show the direction because no 
  internet connection.

2. Explanation
Web links fail because HTTP/HTTPS require internet connection to access to access external websites.
On the other hand, tel:, mailto:, and geo: links work through apps already instaled on the device.
The internet connection can be checked in LinkOpener.open() using a network connectivity
checking package before opening web links with launchURL().
*/
