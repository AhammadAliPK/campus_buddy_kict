import 'package:flutter/material.dart';

class ClearFavouritesScreen extends StatelessWidget{
  const ClearFavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear Favourites'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 12),
            const Text(
              'Clear all your favourite courses?',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                const SizedBox(width: 16),
                FilledButton(
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