import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/next_prayer.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

const prayerCities = ['Kuala Lumpur', 'Kuantan', 'Johor Bahru'];
const _cityKey = 'prayer_city';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key, this.service, this.clock});

  final PrayerService? service; // tests pass a fake service
  final DateTime Function()? clock; // tests pass a fixed "now"

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  late final PrayerService _service = widget.service ?? PrayerService();
  String _city = prayerCities.first;
  late Future<PrayerTimes> _future;

  DateTime _now() => (widget.clock ?? DateTime.now)();

  @override
  void initState() {
    super.initState();
    _future = _service.fetchTimes(_city); // in a FIELD, not inside build
    _restoreCity();
  }

  // Homework stretch: remember the city after a restart.
  Future<void> _restoreCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_cityKey);
      if (saved != null && saved != _city && prayerCities.contains(saved)) {
        if (!mounted) return;
        setState(() {
          _city = saved;
          _future = _service.fetchTimes(_city);
        });
      }
    } catch (e) {
      debugPrint('PrayerScreen: could not read saved city — $e');
    }
  }

  Future<void> _pickCity(String city) async {
    setState(() {
      _city = city;
      _future = _service.fetchTimes(_city);
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cityKey, city);
    } catch (e) {
      debugPrint('PrayerScreen: could not save city — $e');
    }
  }

  void _reload() => setState(() {
    _future = _service.fetchTimes(_city);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer times · $_city'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _reload,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: DropdownButtonFormField<String>(
              initialValue: _city,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: prayerCities
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (c) {
                if (c != null && c != _city) _pickCity(c);
              },
            ),
          ),
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
                return _TimesList(times: times, now: _now());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TimesList extends StatelessWidget {
  const _TimesList({required this.times, required this.now});

  final PrayerTimes times;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Imsak', times.imsak, Icons.bedtime),
      ('Fajr', times.fajr, Icons.nightlight),
      ('Sunrise', times.sunrise, Icons.wb_sunny),
      ('Dhuhr', times.dhuhr, Icons.wb_sunny),
      ('Asr', times.asr, Icons.wb_cloudy),
      ('Sunset', times.sunset, Icons.wb_twilight),
      ('Maghrib', times.maghrib, Icons.brightness_3),
      ('Isha', times.isha, Icons.dark_mode),
    ];
    // Only the five prayers count as "next prayer"; Imsak, Sunrise and Sunset don't.
    const prayers = {'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'};
    final next = nextPrayer([
      for (final (name, time, _) in rows)
        if (prayers.contains(name)) (name, time),
    ], now);
    final scheme = Theme.of(context).colorScheme;
    final big = Theme.of(context).textTheme.titleLarge
        ?.copyWith(fontWeight: FontWeight.bold);

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
              const SizedBox(height: 4),
              Text(
                next == null
                    ? 'All prayers for today have passed'
                    : '${next.name} in ${formatLeft(next.left)}',
                style: TextStyle(color: scheme.primary),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final (name, time, icon) in rows)
                if (next != null && name == next.name)
                  Card(
                    color: scheme.primaryContainer,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Icon(icon),
                      title: Text('$name · next'),
                      trailing: Text(time, style: big),
                    ),
                  )
                else
                  ListTile(
                    leading: Icon(icon),
                    title: Text(name),
                    trailing: Text(time, style: big),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
