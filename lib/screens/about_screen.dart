import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Campus Buddy KICT',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Developer: Muhammad Faiz Nabil bin Faizan'),
            const Text('Version 1.0.0 - Week 6'),
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