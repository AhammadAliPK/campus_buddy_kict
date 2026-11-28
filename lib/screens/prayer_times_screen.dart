import 'dart:async';
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final _service = PrayerService();

  late Future<PrayerTimes> _future;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();

    _future = _service.fetchKlTimes();
    //Update the highlight and countdown without requesting the API again.
    _clockTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }
  void _reload() {
    setState(() {
      _future = _service.fetchKlTimes();
    });
  }
  DateTime? _timeToday(String value, DateTime now) {
    final parts = value.split(':');
    
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (
      hour == null ||
      minute == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59
    ) {
      return null;
    }

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }
  String _countdown(DateTime nextTime, DateTime now) {
    final totalMinutes = (nextTime.difference(now).inSeconds / 60).ceil();
    final hours = totalMinutes ~/60;
    final minutes = totalMinutes % 60;

    if (hours==0){
      return '${minutes}m';
    }
    return '${hours}h ${minutes}m';
  }

  Widget _buildTimes(PrayerTimes times) {
    final now = DateTime.now();
    final colours = Theme.of(context).colorScheme;

    final rows = <(String, String, IconData)>[
      ('Fajr', times.fajr, Icons.nightlight),
      ('Sunrise', times.sunrise, Icons.wb_sunny),
      ('Dhuhr', times.dhuhr, Icons.wb_sunny),
      ('Asr', times.asr, Icons.wb_cloudy),
      ('Maghrib', times.maghrib, Icons.brightness_3),
      ('Isha', times.isha, Icons.dark_mode),
    ];
    String? nextPrayer;
    DateTime? nextTime;

    for (final (name, time, _) in rows) {
      if (name == 'Sunrise'){
        continue;
      }
      final prayerTime = _timeToday(time, now);
      if (prayerTime != null && prayerTime.isAfter(now)){
        nextPrayer = name;
        nextTime = prayerTime;
        break;
      }
    }
    final countdownText = nextTime != null ? '$nextPrayer in ${_countdown(nextTime, now)}': 'All prayers for today have passed.';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              Text(
                countdownText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colours.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${times.gregorianDate} · Kuala Lumpur',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final (name, time, icon) in rows)
              Card(
                color: name == nextPrayer? colours.primaryContainer: null,
                child: ListTile(
                  leading: Icon(icon),
                  title: Text(name),
                  subtitle: name == nextPrayer? const Text('Next prayer'): null,
                  trailing: Text(
                    time,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer times · KL'),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: 'refresh prayer times',
          ),
        ],
      ),
      body: FutureBuilder<PrayerTimes>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (snapshot.hasError){
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load prayer times.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Details: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
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
          return _buildTimes(snapshot.data!);
        },
      ),
    );
  }
}