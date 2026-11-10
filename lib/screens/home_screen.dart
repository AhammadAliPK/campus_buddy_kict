import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/placeholder_screen.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:campus_buddy_kict/services/app_share.dart';
import 'package:campus_buddy_kict/screens/confirm_screen.dart';

// Week 6 exercise — why Home cannot clear the favourites:
// The favourites are stored in _courses, a private variable inside
// _CoursesScreenState, and only that State can read it or call setState on it.
// HomeScreen is a separate widget that sits beside CoursesScreen in the
// IndexedStack, so it holds no reference to that list and has no way to change
// it. To fix this, the course list would have to be lifted out of the Courses
// screen into shared app state that both screens can reach — this is called
// state management. For now, the working button is on the Courses tab.

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
            onPressed: AppShare.share,
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PlaceholderScreen(title: 'Prayer times', arrivesWeek: 8),
                ),
              ),
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
              leading: const Icon(Icons.star_outline),
              title: const Text('Clear all favourites'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                final yes = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConfirmScreen(
                      message: 'Remove the star from every course?',
                    ),
                  ),
                );
                if (yes != true) return;
                // We got "yes", but Home cannot reach the Courses list.
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Home can't reach your courses — use the ☆ button "
                      'on the Courses tab instead.',
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Campus Buddy KICT'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/about'),  // the named route!
            ),
          ),
        ],
      ),
    );
  }
}