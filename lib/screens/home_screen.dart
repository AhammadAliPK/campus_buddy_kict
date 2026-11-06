import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/screens/prayer_times_screen.dart';
import 'package:campus_buddy_kict/screens/campus_links_screen.dart';

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
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.wb_twilight),
                title: Text('Prayer times'),
                subtitle: Text('Arrives in Week 8'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrayerTimesScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.link),
                title: Text('Campus links'),
                subtitle: Text('Arrives in Week 7'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CampusLinksScreen(),
                    ),
                  );
                },
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
          ],
        ),
      ),
    );
  }
}
