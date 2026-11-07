
import 'package:flutter/material.dart';

class ClearFavoritesScreen extends StatelessWidget {
  const ClearFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear Favourites'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure?'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
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
