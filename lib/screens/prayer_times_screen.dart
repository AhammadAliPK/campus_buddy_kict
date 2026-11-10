import 'package:flutter/material.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
      ), // Change title accordingly
      body: const Center(child: Text('Arrives in a later week')),
    );
  }
}
