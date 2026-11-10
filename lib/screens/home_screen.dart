import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () => Navigator.pushNamed(context, '/about')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // In-class exercise: The button that opens a Scaffold but can't reach the data
          ElevatedButton(
            onPressed: () async {
              final confirm = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const ConfirmClearScreen()),
              );
              if (confirm == true) {
                // We can't actually clear favorites here because _courses lives in CoursesScreen!
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot reach courses data from Home!')));
              }
            },
            child: const Text('Clear All Favourites (Broken)'),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.wb_twilight), title: const Text('Prayer times'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link), title: const Text('Campus links'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// Full screen confirmation for the exercise
class ConfirmClearScreen extends StatelessWidget {
  const ConfirmClearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure you want to clear all favourites?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                const SizedBox(width: 16),
                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
              ],
            )
          ],
        ),
      ),
    );
  }
}