import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,              // only as tall as its content → centred
          children: [
            Text('Campus Buddy KICT',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('CSCI 4311 Mobile Application Development'),
            const Text('Developer: MUAHAHAHA'),        // ← your name
            const Text('1.0.0 · Week 6'),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context), // close → back to where you came from
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}