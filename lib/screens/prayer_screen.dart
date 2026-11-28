import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';
import 'package:flutter/material.dart';

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

  void _reload() {
    setState(() {
      _future = _service.fetchKlTimes();
    });
  }

  int? _nextPrayerIndex(List<(String, String, IconData)> rows) {
    final now = DateTime.now();
    for (var index = 0; index < rows.length; index++) {
      final timeParts = rows[index].$2.split(':');
      if (timeParts.length != 2) {
        continue;
      }

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) {
        continue;
      }

      final prayerTime = DateTime(now.year, now.month, now.day, hour, minute);
      if (prayerTime.isAfter(now)) {
        return index;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer times · KL'),
        actions: [
          IconButton(
            tooltip: 'Refresh prayer times',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
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
              child: Padding(
                padding: const EdgeInsets.all(24),
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

          final times = snapshot.data!;
          final rows = <(String, String, IconData)>[
            ('Fajr', times.fajr, Icons.nightlight),
            ('Sunrise', times.sunrise, Icons.wb_sunny),
            ('Dhuhr', times.dhuhr, Icons.wb_sunny),
            ('Asr', times.asr, Icons.wb_cloudy),
            ('Maghrib', times.maghrib, Icons.brightness_3),
            ('Isha', times.isha, Icons.dark_mode),
          ];
          final nextPrayerIndex = _nextPrayerIndex(rows);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${times.gregorianDate} · Malaysia method',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var index = 0; index < rows.length; index++)
                      Card(
                        color: index == nextPrayerIndex
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          leading: Icon(rows[index].$3),
                          title: Text(rows[index].$1),
                          trailing: Text(
                            rows[index].$2,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
