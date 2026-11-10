import 'package:flutter/material.dart';

class CampusLinksScreen extends StatelessWidget {
  const CampusLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Links'),
      ), // Change title accordingly
      body: const Center(child: Text('Arrives in a later week')),
    );
  }
}
