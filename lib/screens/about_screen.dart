import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About')
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Adnaan - v1.0.0 - Week 6'),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close")
            )
          ]
        )
      ),
    );
  }
}