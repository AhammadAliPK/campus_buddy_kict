
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                size: 80,
                color: Colors.teal,
              ),

              const SizedBox(height: 20),

              Text(
                'Campus Buddy KICT',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 12),

              const Text(
                'Developed by: Zaid Shamsuddin',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text('Version 1.0.0 · Week 6'),

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
