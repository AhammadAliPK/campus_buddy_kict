import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  DateTime _getPrayerDateTime(String time, DateTime date) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  final _service = PrayerService();
  late Future<PrayerTimes> _future;
  @override
  void initState() {
    super.initState();
    _future = _service.fetchKlTimes(); // in a FIELD — see tip below
  }

  void _reload() => setState(() {
    _future = _service.fetchKlTimes();
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrayerTimes>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('Prayer times · KL')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Prayer times · KL')),
            body: Center(
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

        final rows = [
          ('Fajr', times.fajr, Icons.nightlight),
          ('Sunrise', times.sunrise, Icons.wb_sunny),
          ('Dhuhr', times.dhuhr, Icons.wb_sunny),
          ('Asr', times.asr, Icons.wb_cloudy),
          ('Maghrib', times.maghrib, Icons.brightness_3),
          ('Isha', times.isha, Icons.dark_mode),
        ];

        final now = DateTime.now();

        final upcomingPrayers = rows.where((row) {
          final prayerDateTime = _getPrayerDateTime(row.$2, now);
          return prayerDateTime.isAfter(now);
        }).toList();

        final nextPrayer = upcomingPrayers.isNotEmpty
            ? upcomingPrayers.first
            : null;

        final nextPrayerTime = nextPrayer != null
            ? _getPrayerDateTime(nextPrayer.$2, now)
            : null;

        final remaining = nextPrayerTime != null
            ? nextPrayerTime.difference(now)
            : Duration.zero;

        final countdownHours = remaining.inHours;
        final countdownMinutes = remaining.inMinutes % 60;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Prayer times · KL'),
                if (nextPrayer != null)
                  Text(
                    '${nextPrayer.$1} in ${countdownHours}h ${countdownMinutes}m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
            ],
          ),
          body: Column(
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
                    for (final (name, time, icon) in rows)
                      Card(
                        color: nextPrayer != null && name == nextPrayer.$1
                              ? Colors.green.shade100
                            : null,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Icon(icon),
                          title: Text(
                            name,
                            style: TextStyle(
                              fontWeight:
                                  nextPrayer != null && name == nextPrayer.$1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: Text(
                            time,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
