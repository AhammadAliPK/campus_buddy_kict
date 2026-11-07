import 'package:flutter/material.dart';

class ClearFavoritesScreen extends StatelessWidget {
  const ClearFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Are you sure?')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Clear all favourites?'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // Pops false
                  child: const Text('No'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true), // Pops true
                  child: const Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}