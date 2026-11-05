import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, size: 64),
            const SizedBox(height: 16),
            Text('Campus Buddy KICT',
                style: Theme.of(context).textTheme.headlineSmall),
            const Text('CSCI 4311 · Mobile Application Development'),
            const SizedBox(height: 8),
            const Text('Developer: salehuddiniwan'),
            const Text('1.0.0 · Week 6'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}