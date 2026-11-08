import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 64),
            const SizedBox(height: 16),
            Text('Campus Buddy KICT',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('1.0.0 · Week 6'),
            const SizedBox(height: 16),
            const Text('Developed by Imran Nazuhr'),
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
