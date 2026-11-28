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
    // Kept in a FIELD so a rebuild does not fire a new request.
    _future = _service.fetchKlTimes();
  }

  void _reload() => setState(() {
        _future = _service.fetchKlTimes();
      });

  /// "HH:MM" -> minutes since midnight, or null if it isn't a time (e.g. '—').
  int? _toMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  /// "Asr in 2h 15m"
  String _countdown(String name, int minutesLeft) {
    final h = minutesLeft ~/ 60;
    final m = minutesLeft % 60;
    if (h == 0) return '$name in ${m}m';
    return '$name in ${h}h ${m}m';
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
          // State 1 — still waiting: spinner.
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2 — failed (no internet, timeout, bad status): message + Retry.
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
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
              ),
            );
          }

          // State 3 — success: the list.
          final times = snapshot.data!;
          final rows = [
            ('Fajr', times.fajr, Icons.nightlight),
            ('Sunrise', times.sunrise, Icons.wb_sunny),
            ('Dhuhr', times.dhuhr, Icons.wb_sunny),
            ('Asr', times.asr, Icons.wb_cloudy),
            ('Maghrib', times.maghrib, Icons.brightness_3),
            ('Isha', times.isha, Icons.dark_mode),
          ];

          // Step 7 — find the first row that is still ahead of "now".
          final now = DateTime.now();
          final nowMinutes = now.hour * 60 + now.minute;
          int? nextIndex;
          for (var i = 0; i < rows.length; i++) {
            final mins = _toMinutes(rows[i].$2);
            if (mins != null && mins > nowMinutes) {
              nextIndex = i;
              break;
            }
          }

          // Step 8 (bonus) — "Asr in 2h 15m".
          final String countdownText;
          if (nextIndex != null) {
            final left = _toMinutes(rows[nextIndex].$2)! - nowMinutes;
            countdownText = _countdown(rows[nextIndex].$1, left);
          } else {
            countdownText = 'Isha has passed · Fajr tomorrow';
          }

          final scheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: scheme.primaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  countdownText,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: scheme.onPrimaryContainer),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('${times.gregorianDate} · Malaysia method',
                    style: textTheme.titleMedium),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (final (i, (name, time, icon)) in rows.indexed)
                      _buildRow(
                        name: name,
                        time: time,
                        icon: icon,
                        isNext: i == nextIndex,
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

  Widget _buildRow({
    required String name,
    required String time,
    required IconData icon,
    required bool isNext,
  }) {
    final tile = ListTile(
      leading: Icon(icon),
      title: Text(name),
      subtitle: isNext ? const Text('Next') : null,
      trailing: Text(
        time,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );

    if (!isNext) return tile;

    // The next prayer gets a coloured Card around it.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: tile,
    );
  }
}
