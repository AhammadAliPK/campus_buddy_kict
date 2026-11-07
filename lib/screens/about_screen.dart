
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Campus Buddy KICT'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                size: 72,
              ),

              const SizedBox(height: 16),

              const Text(
                'Campus Buddy KICT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'CSCI 4311 · Mobile Application Development',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Developer: Syarifah Noraqielah',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Version 1.0.0 · Week 6',
              ),

              const SizedBox(height: 32),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
