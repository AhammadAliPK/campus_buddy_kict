
import 'package:flutter/material.dart';

class CampusLinksScreen extends StatelessWidget {
  const CampusLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Links'),
      ),
      body: const Center(
        child: Text(
          'Campus Links Feature Coming in Week 7',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
