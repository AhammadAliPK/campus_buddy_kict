import 'package:flutter/material.dart';

// Step 7: a fixed page, opened by name ('/about')
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school,
                  size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Campus Buddy KICT', style: text.headlineSmall),
              const SizedBox(height: 8),
              const Text('CSCI 4311 · Mobile Application Development',
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Developer: Zulharizi'),
              const SizedBox(height: 8),
              Text('1.0.0 · Week 6', style: text.bodySmall),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
