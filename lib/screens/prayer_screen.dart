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
    _future = _service.fetchKlTimes(); // in a FIELD — see tip below
  }

  void _reload() => setState(() {
        _future = _service.fetchKlTimes();
      });

  /// "HH:MM" -> minutes since midnight, null if missing/unparseable.
  int? _toMinutes(String time) {
    if (time == '—' || !time.contains(':')) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer times · KL'),
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

          // --- Step 7: highlight the next prayer ---
          final now = DateTime.now();
          final nowMinutes = now.hour * 60 + now.minute;
          int nextIndex = -1;
          for (var i = 0; i < rows.length; i++) {
            final mins = _toMinutes(rows[i].$2);
            if (mins != null && mins > nowMinutes) {
              nextIndex = i;
              break;
            }
          }
          // After Isha: wrap to Fajr tomorrow.
          final wrapped = nextIndex == -1;
          if (wrapped) nextIndex = 0;

          // --- Step 8 (bonus): "Asr in 2h 15m" ---
          String countdown = '';
          final nextMinutes = _toMinutes(rows[nextIndex].$2);
          if (nextMinutes != null) {
            var diff = (nextMinutes - nowMinutes + 24 * 60) % (24 * 60);
            final h = diff ~/ 60;
            final m = diff % 60;
            final name = rows[nextIndex].$1;
            countdown = wrapped
                ? '$name tomorrow in ${h}h ${m}m'
                : '$name in ${h}h ${m}m';
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Text('${times.gregorianDate} · Malaysia method',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              if (countdown.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(countdown,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.primary)),
                ),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < rows.length; i++)
                      if (i == nextIndex)
                        Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: ListTile(
                            leading: Icon(rows[i].$3),
                            title: Text(rows[i].$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: Text(rows[i].$2,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        )
                      else
                        ListTile(
                          leading: Icon(rows[i].$3),
                          title: Text(rows[i].$1),
                          trailing: Text(rows[i].$2,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
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
