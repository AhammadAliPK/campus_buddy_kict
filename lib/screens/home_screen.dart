import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';   // the real links page instead of the placeholder
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {    // HomeScreen is a StatelessWidget because it has no changing state. It just shows a menu of cards and responds to taps.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),                 // share button in the app bar
            tooltip: 'Share',
            onPressed: () => SharePlus.instance.share(     // open the share sheet
              ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),   // ShareParams = the content to share. text = the text to share. Can also share files, URLs, etc.
            ),
          ),
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
          Card(child: ListTile(   // The "Campus links" card. Tap → open the links page. The links page has a list of links, each of which opens the link in a browser or app.
            leading: const Icon(Icons.link),
            title: const Text('Campus links'),
            subtitle: const Text('Websites, map, call, email, share'), //subtitle = smaller text under the title
            trailing: const Icon(Icons.chevron_right),    // trailing: the ">" arrow = "opens something"
            onTap: () async {                                // tap → open the links page
              await Navigator.push<bool>(                    // push a new screen on top of this one, wait for it to finish and return a value
                context,                                     // context = this screen, the one that called Navigator.push
                MaterialPageRoute(builder: (_) => const LinksScreen()), // MaterialPageRoute = a new page that slides in from the right. builder = what to show on that page. _ = "the argument I'm given isn't needed"
              );
            },
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Campus Buddy KICT'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/about'), // same page as the ⓘ
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Clear all favourites'),
            onTap: () async {
              final yes = await Navigator.push<bool>(context,
                  MaterialPageRoute(builder: (_) =>
                      const ConfirmScreen(message: 'Clear all favourites?')));
              if (yes == true && context.mounted) {
                // context.mounted = "is this screen still on display?" (VS Code warns without it)
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Home can't reach the favourites. Use the Courses tab.")));
              }
            },
          )),
        ],
      ),
    );
  }
}