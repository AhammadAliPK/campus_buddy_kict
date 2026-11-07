
import 'package:flutter/material.dart';

class ClearFavouritesScreen extends StatelessWidget {
  const ClearFavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear Favourites'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_border,
                size: 64,
                color: Colors.amber,
              ),

              const SizedBox(height: 20),

              const Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Do you want to remove all your favourite stars?',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
