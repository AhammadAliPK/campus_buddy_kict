import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 64, color: Colors.teal),
              const SizedBox(height: 16),
              Text(
                'Campus Buddy KICT',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Version 1.0.0 · Week 6'),
              const SizedBox(height: 16),
              const Text(
                'Developed for CSCI 4311\nMobile Application Development',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
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