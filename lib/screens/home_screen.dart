import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';
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
                  text: 'Campus Buddy KICT - built in CSCI 4311 at IIUM.',
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
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(child: ListTile(
            leading: Icon(Icons.wb_twilight),
            title: Text('Prayer times'),
            subtitle: Text('Arrives in Week 8'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/prayer_times'),
          )),
          Card(child: ListTile(
            leading: Icon(Icons.link),
            title: Text('Campus links'),
            subtitle: Text('Websites, map, call, email, share'),
            onTap: () async {
              await Navigator.push<bool>(context,
              MaterialPageRoute(builder: (_) => const LinksScreen()));
            }
          )),
          Card(child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Campus Buddy KICT'),
            subtitle: Text('Arrives in Week 9'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/about'),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Clear all favourites'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final ok = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConfirmScreen(
                    message: 'Clear all favourites?',
                  ),
                ),
              );

              if (ok == true) {
               // Clear favourites logic here
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                  content: Text("Can't clear from Home. Use the Courses tab.")
                  ),
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
