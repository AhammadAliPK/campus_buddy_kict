import 'package:flutter/cupertino.dart';
import 'package:campus_buddy_kict/screens/about_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Campus Buddy KICT'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.info),
          onPressed: () => Navigator.pushNamed(context, '/about'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CupertinoListSection.insetGrouped(
              header: const Text('QUICK ACCESS'),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.time),
                  title: const Text('Prayer times'),
                  subtitle: const Text('Arrives in Week 8'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const PlaceholderScreen(title: 'Prayer Times'),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.link),
                  title: const Text('Campus links'),
                  subtitle: const Text('Arrives in Week 7'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const PlaceholderScreen(title: 'Campus Links'),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.info_circle),
                  title: const Text('About Campus Buddy KICT'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => Navigator.pushNamed(context, '/about'), // FIXED from onPressed to onTap
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: SafeArea(
        child: Center(
          child: Text(
            '$title coming soon!',
            style: const TextStyle(fontSize: 18, color: CupertinoColors.systemGrey),
          ),
        ),
      ),
    );
  }
}