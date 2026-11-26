import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final _service = PrayerService();
  late Future<PrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchKlTimes();
    // in a FIELD — see tip below
  }

  void _reload() => setState(() {
        _future = _service.fetchKlTimes();
      });

  String nextPrayerCountdown(PrayerTimes times) {
    final entries = [
      ('Fajr', times.fajr),
      ('Sunrise', times.sunrise),
      ('Dhuhr', times.dhuhr),
      ('Asr', times.asr),
      ('Maghrib', times.maghrib),
      ('Isha', times.isha),
    ];

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    for (final entry in entries) {
      final parts = entry.$2.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;

      final prayerMinutes = hour * 60 + minute;
      if (prayerMinutes > nowMinutes) {
        final difference = prayerMinutes - nowMinutes;
        final hours = difference ~/ 60;
        final minutes = difference % 60;
        return '${entry.$1} in ${hours}h ${minutes}m';
      }
    }

    return 'No more times today';
  }    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: FutureBuilder<PrayerTimes>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return const Text('Prayer times · KL');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Prayer times · KL'),
                Text(
                  nextPrayerCountdown(snapshot.data!),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: FutureBuilder<PrayerTimes>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 56),
                  const SizedBox(height: 12),
                  Text('Could not load times\n${snapshot.error}',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final times = snapshot.data!;
          final rows = [
            ('Fajr', times.fajr, Icons.nightlight),
            ('Sunrise', times.sunrise, Icons.wb_sunny),
            ('Dhuhr', times.dhuhr, Icons.wb_sunny),
            ('Asr', times.asr, Icons.wb_cloudy),
            ('Maghrib', times.maghrib, Icons.brightness_3),
            ('Isha', times.isha, Icons.dark_mode),
          ];
          final now = DateTime.now();
          final nowMinutes = now.hour * 60 + now.minute;
          final nextPrayerIndex = rows.indexWhere((row) {
            final parts = row.$2.split(':');

            if (parts.length != 2) return false;

            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);

            if (hour == null || minute == null) return false;

            return hour * 60 + minute > nowMinutes;
          });
          Widget buildPrayerRow(int index) {
            final row = rows[index];

            final isNextPrayer = index == nextPrayerIndex;

            final tile = ListTile(
              leading: Icon(row.$3),
              title: Text(row.$1),
              trailing: Text(
                row.$2,
                style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
              ),
            );

            if (isNextPrayer) {
              return Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: tile,
              );
            }
            return tile;
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('${times.gregorianDate} · Malaysia method',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < rows.length; i++)
                    buildPrayerRow(i),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
