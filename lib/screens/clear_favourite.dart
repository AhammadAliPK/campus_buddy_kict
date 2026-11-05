import 'package:flutter/material.dart';

class ClearFavouritesConfirmScreen extends StatelessWidget {
  const ClearFavouritesConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clear Favourites')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Do you want to clear all your favourite courses?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
