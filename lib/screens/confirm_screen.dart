import 'package:flutter/material.dart';

/// A whole screen (not a popup) that answers: pops true (Yes) or false (No).
/// System back pops null, which callers treat as "No".
class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Are you sure?')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Are you sure?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
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
