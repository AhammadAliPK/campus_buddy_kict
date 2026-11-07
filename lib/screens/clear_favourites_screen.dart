import 'package:flutter/material.dart';

class ClearFavoritesScreen extends StatelessWidget {
  const ClearFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clear Favourites')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure you want to unstar all courses?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // Pops false
                  child: const Text('No, cancel'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true), // Pops true
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Yes, clear them'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}