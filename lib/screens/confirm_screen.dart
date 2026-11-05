import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key, required this.message});
  final String message;                                  // the question to show

  @override
  Widget build(BuildContext context) {
    return Scaffold(                                     // a WHOLE screen, not a popup
      appBar: AppBar(title: const Text('Please confirm')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false), // answer: NO
                  child: const Text('No'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),  // answer: YES
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