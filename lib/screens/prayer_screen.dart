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
  }

  void _reload() => setState(() {
        _future = _service.fetchKlTimes();
      });

  // Helper to find the next prayer index and remaining time (Steps 7 & 8)
  (int?, String?) _getNextPrayerInfo(List<(String, String, IconData)> rows) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    for (int i = 0; i < rows.length; i++) {
      final (name, time, _) = rows[i];
      final parts = time.split(':');
      if (parts.length < 2) continue;

      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) continue;

      final prayerMinutes = h * 60 + m;
      if (prayerMinutes > nowMinutes) {
        final diff = prayerMinutes - nowMinutes;
        final hoursLeft = diff ~/ 60;
        final minsLeft = diff % 60;
        final countdown = hoursLeft > 0
            ? '$name in ${hoursLeft}h ${minsLeft}m'
            : '$name in ${minsLeft}m';
        return (i, countdown);
      }
    }
    return (null, null); // All prayers for today have passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer times KL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<PrayerTimes>(
        future: _future,
        builder: (context, snapshot) {
          // 1. Loading state
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error state
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 56),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load times\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Data state
          final times = snapshot.data!;
          final rows = [
            ('Fajr', times.fajr, Icons.nightlight),
            ('Sunrise', times.sunrise, Icons.wb_sunny),
            ('Dhuhr', times.dhuhr, Icons.wb_sunny),
            ('Asr', times.asr, Icons.wb_cloudy),
            ('Maghrib', times.maghrib, Icons.brightness_3),
            ('Isha', times.isha, Icons.dark_mode),
          ];

          final (nextIndex, countdownText) = _getNextPrayerInfo(rows);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      '${times.gregorianDate} · Malaysia method',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (countdownText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        countdownText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final (name, time, icon) = rows[index];
                    final isNext = index == nextIndex;

                    final tile = ListTile(
                      leading: Icon(icon),
                      title: Text(name),
                      trailing: Text(
                        time,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    );

                    // Step 7: Highlight the next upcoming prayer
                    if (isNext) {
                      return Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: tile,
                      );
                    }
                    return tile;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}