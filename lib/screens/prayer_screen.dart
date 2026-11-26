import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  static const _cityKey = 'selected_prayer_city';
  static const _cities = [
    'Kuala Lumpur',
    'Kuantan',
    'Seremban',
    'Johor Bahru',
    'George Town',
  ];

  final _service = PrayerService();
  final _prefs = SharedPreferencesAsync();
  String _selectedCity = _cities.first;
  late Future<PrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadSavedCityAndFetch(); // in a FIELD — see tip below
  }

  Future<PrayerTimes> _loadSavedCityAndFetch() async {
    final savedCity = await _prefs.getString(_cityKey);
    if (savedCity != null && _cities.contains(savedCity)) {
      _selectedCity = savedCity;
      if (mounted) setState(() {});
    }
    return _service.fetchTimes(_selectedCity);
  }

  void _reload() => setState(() {
    _future = _service.fetchTimes(_selectedCity);
  });

  Future<void> _onCityChanged(String? newCity) async {
    if (newCity == null || newCity == _selectedCity) return;
    setState(() {
      _selectedCity = newCity;
      _future = _service.fetchTimes(_selectedCity);
    });
    await _prefs.setString(_cityKey, newCity);
  }

  int? _toMinutes(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrayerTimes>(
      future: _future,
      builder: (context, snapshot) {
        String? nextName;
        String? nextCountdown;
        List<(String, String, IconData)> rows = [];

        // Step 7 & 8: Compute next prayer + countdown once data is ready
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError &&
            snapshot.hasData) {
          final times = snapshot.data!;
          rows = [
            ('Imsak', times.imsak, Icons.bedtime_outlined),
            ('Fajr', times.fajr, Icons.nightlight),
            ('Sunrise', times.sunrise, Icons.wb_sunny),
            ('Dhuhr', times.dhuhr, Icons.wb_sunny),
            ('Asr', times.asr, Icons.wb_cloudy),
            ('Sunset', times.sunset, Icons.wb_twilight),
            ('Maghrib', times.maghrib, Icons.brightness_3),
            ('Isha', times.isha, Icons.dark_mode),
          ];

          final now = DateTime.now();
          final nowMins = now.hour * 60 + now.minute;

          for (final (name, time, _) in rows) {
            final prayerMins = _toMinutes(time);
            if (prayerMins != null && prayerMins > nowMins) {
              final diff = prayerMins - nowMins;
              nextName = name;
              nextCountdown = '$name in ${diff ~/ 60}h ${diff % 60}m';
              break;
            }
          }

          // Fallback after Isha so tomorrow's Fajr is still highlighted
          if (nextName == null) {
            final fajrMins = _toMinutes(times.fajr);
            if (fajrMins != null) {
              final diff = (24 * 60 - nowMins) + fajrMins;
              nextName = 'Fajr';
              nextCountdown = 'Fajr in ${diff ~/ 60}h ${diff % 60}m';
            }
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prayer times · $_selectedCity'),
                if (nextCountdown != null)
                  Text(
                    nextCountdown,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('City'),
                    DropdownButton<String>(
                      value: _selectedCity,
                      items: _cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: _onCityChanged,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Builder(
                  builder: (context) {
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
                      );
                    }

                    final times = snapshot.data!;
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
                              ...rows.map((row) {
                                final (name, time, icon) = row;
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

                                if (name == nextName) {
                                  return Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    child: tile,
                                  );
                                }
                                return tile;
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}