import 'package:flutter/material.dart';

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StubScreen(title: 'Prayer Times')),
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
                  MaterialPageRoute(builder: (context) => const StubScreen(title: 'Campus Links')),
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
    );
  }
}

class StubScreen extends StatelessWidget {
  const StubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title coming soon')),
    );
  }
}
