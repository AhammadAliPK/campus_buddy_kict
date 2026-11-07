
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('CSCI 4311 · Mobile Application Development'),
            const SizedBox(height: 12),
            const Text('Developer: husna'),
            const SizedBox(height: 12),
            const Text('1.0.0 · Week 6'),
            const SizedBox(height: 24),
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
