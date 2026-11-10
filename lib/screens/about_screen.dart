
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CSCI 4311',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Mobile Application Development',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            const Text(
              'Developer: Lisa',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            const Text(
              '1.0.0 · Week 6',
              style: TextStyle(fontSize: 16),
            ),

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
