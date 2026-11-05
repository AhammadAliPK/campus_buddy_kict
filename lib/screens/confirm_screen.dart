import 'package:flutter/material.dart';

// Exercise: a whole screen (not a popup) that answers true or false.
class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Are you sure?')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.help_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Are you sure?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => Navigator.pop(context, true), // the answer
              child: const Text('Yes'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
          ],
        ),
      ),
    );
  }
}
