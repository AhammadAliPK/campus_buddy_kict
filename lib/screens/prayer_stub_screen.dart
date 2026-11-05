import 'package:flutter/material.dart';

class PrayerStubScreen extends StatelessWidget {
  const PrayerStubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer times')),
      body: const Center(child: Text('Arrives in Week 8')),
    );
  }
}
