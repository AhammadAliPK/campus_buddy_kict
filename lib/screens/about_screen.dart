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
            const Text('Campus Buddy KICT',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('CSCI 4311 Mobile Application Development'),
            const SizedBox(height: 8),
            const Text('Developer: Muhammad Harith Ikhwan (2310515)'),   // ← your name
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