import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mobile Application Development',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              SizedBox(height: 8),
              Text('Developer: Izzat'),
              SizedBox(height: 8),
              Text('1.0.0 · Week 6'),
              SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
