import 'package:flutter/material.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer times')),
      body: const Center(
        child: Text('Prayer times — coming in Week 8'),
      ),
    );
  }
}
