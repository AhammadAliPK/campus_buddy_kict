import 'package:flutter/material.dart';

import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() {
    return _PrayerTimesScreenState();
  }
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late Future<PrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = PrayerService.fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: FutureBuilder<PrayerTimes>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _PrayerList(times: snapshot.data!);
          }

          if (snapshot.hasError) {
            return _ErrorView(
              onRetry: () {
                setState(_reload);
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _PrayerList extends StatelessWidget {
  const _PrayerList({required this.times});

  final PrayerTimes times;

  @override
  Widget build(BuildContext context) {
    final prayers = [
      ('Fajr', times.fajr, Icons.nightlight),
      ('Dhuhr', times.dhuhr, Icons.wb_sunny),
      ('Asr', times.asr, Icons.wb_twilight),
      ('Maghrib', times.maghrib, Icons.wb_twilight),
      ('Isha', times.isha, Icons.nights_stay),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Kuala Lumpur, Malaysia',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Today prayer times', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        ...prayers.map(
          (prayer) => Card(
            child: ListTile(
              leading: Icon(prayer.$3),
              title: Text(prayer.$1),
              trailing: Text(
                prayer.$2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Unable to load prayer times.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
