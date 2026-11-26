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
  static const _prefsKey = 'selected_prayer_city';
  static const _cities = ['Kuala Lumpur', 'Kuantan', 'Johor Bahru'];

  final _service = PrayerService();
  String _selectedCity = 'Kuala Lumpur';
  late Future<PrayerTimes> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadSavedCityAndFetch();
  }

  Future<PrayerTimes> _loadSavedCityAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString(_prefsKey);
    if (savedCity != null && _cities.contains(savedCity)) {
      if (mounted) {
        setState(() => _selectedCity = savedCity);
      } else {
        _selectedCity = savedCity;
      }
    }
    return _service.fetchTimes(_selectedCity);
  }

  Future<void> _onCityChanged(String? newCity) async {
    if (newCity == null || newCity == _selectedCity) return;
    setState(() {
      _selectedCity = newCity;
      _future = _service.fetchTimes(newCity);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, newCity);
  }

  void _reload() => setState(() {
        _future = _service.fetchTimes(_selectedCity);
      });

  DateTime? _parseTodayTime(String timeStr, DateTime now) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer times'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: Column(
        children: [
          // Task 1: City Picker Dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.location_city),
                const SizedBox(width: 12),
                const Text('City:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCity,
                    isExpanded: true,
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
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<PrayerTimes>(
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
                  ('Imsak', times.imsak, Icons.nights_stay_outlined),
                  ('Fajr', times.fajr, Icons.nightlight),
                  ('Sunrise', times.sunrise, Icons.wb_sunny),
                  ('Dhuhr', times.dhuhr, Icons.wb_sunny),
                  ('Asr', times.asr, Icons.wb_cloudy),
                  ('Maghrib', times.maghrib, Icons.brightness_3),
                  ('Sunset', times.sunset, Icons.wb_twilight),
                  ('Isha', times.isha, Icons.dark_mode),
                ];

          final now = DateTime.now();
          int nextIndex = -1;
          String countdownText = 'All prayers completed for today';

          for (int i = 0; i < rows.length; i++) {
            final prayerDt = _parseTodayTime(rows[i].$2, now);
            if (prayerDt != null && prayerDt.isAfter(now)) {
              nextIndex = i;
              final diff = prayerDt.difference(now);
              final hours = diff.inHours;
              final mins = diff.inMinutes % 60;
              countdownText = '${rows[i].$1} in ${hours}h ${mins}m';
              break;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                    '${times.gregorianDate} · $_selectedCity (Malaysia method)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  countdownText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
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

                    if (isNext) {
                      return Card(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
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
      ), 
    ], 
  ), 
); 
  }
}