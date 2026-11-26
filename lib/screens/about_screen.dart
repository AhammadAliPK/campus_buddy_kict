import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campus Buddy KICT', style: text.headlineSmall),
            const SizedBox(height: 8),
            const Text('CSCI 4311 Mobile Application Development · IIUM KICT'),
            const SizedBox(height: 16),
            const Text(
              'Developer: Muhammad Zulnazmi Rafiqi bin Azhary (2311687)',
            ),
            const SizedBox(height: 8),
            const Text('1.0.0 · Week 6'),
            const Spacer(),
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
