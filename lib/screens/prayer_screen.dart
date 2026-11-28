import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final _service = PrayerService();
  final _prefs = SharedPreferencesAsync();
  String _selectedCity = 'Kuala Lumpur';

  late Future<PrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadSavedCity();
  }

  Future<PrayerTimes> _loadSavedCity() async {
    final savedCity = await _prefs.getString('selected_city');
    final cities = {'Kuala Lumpur', 'Kota Bharu', 'Putrajaya'};
    final city = cities.contains(savedCity) ? savedCity! : 'Kuala Lumpur';

    if (mounted) {
      setState(() {
        _selectedCity = city;
      });
    }

    return _service.fetchTimesForCity(city);
  }
  
  void _reload() {
    setState(() {
      
      _future = _service.fetchTimesForCity(_selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: _selectedCity,
          isExpanded: true,
          items: const [
            'Kuala Lumpur',
            'Kota Bharu',
            'Putrajaya',
          ].map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (city) async {
            if (city == null) return;
            setState(() {
              _selectedCity = city;
              _future = _service.fetchTimesForCity(city);
            });
            await _prefs.setString('selected_city', city);
          },
        ),
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
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
          final rows = [
            ('Imsak', times.imsak, Icons.nightlight),
            ('Fajr', times.fajr, Icons.nightlight),
            ('Sunrise', times.sunrise, Icons.wb_sunny),
            ('Dhuhr', times.dhuhr, Icons.wb_sunny),
            ('Asr', times.asr, Icons.wb_cloudy),
            ('Sunset', times.sunset, Icons.nightlight),
            ('Maghrib', times.maghrib, Icons.brightness_3),
            ('Isha', times.isha, Icons.dark_mode),
          ];

          final now = DateTime.now();
          final currentMinutes = now.hour * 60 + now.minute;

          final upcomingIndex = rows.indexWhere((row) {
            final parts = row.$2.split(':');
            final hour = int.parse(parts[0]);
            final minute = int.parse(parts[1]);

            return hour * 60 + minute > currentMinutes;
          });

          final nextIndex = upcomingIndex == -1 ? 0 : upcomingIndex;

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
                    for (var i = 0; i < rows.length; i++)
                      Card(
                        color: i == nextIndex
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          leading: Icon(rows[i].$3),
                          title: Text(rows[i].$1),
                          trailing: Text(
                            rows[i].$2,
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