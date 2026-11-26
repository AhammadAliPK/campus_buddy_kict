import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';
import 'package:flutter/foundation.dart';

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
      final rows = [('Fajr', times.fajr, Icons.nightlight),
      ('Sunrise', times.sunrise, Icons.wb_sunny),
      ('Dhuhr', times.dhuhr, Icons.wb_sunny),
      ('Asr', times.asr, Icons.wb_cloudy),
      ('Maghrib', times.maghrib, Icons.brightness_3),
      ('Isha', times.isha, Icons.dark_mode),
      ];
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('${times.gregorianDate} · Malaysia method',
              style: Theme.of(context).textTheme.titleMedium),
      ),
        Expanded(
          child: ListView(
            children: [
              for (final (name, time, icon) in rows)
                ListTile(
                  leading: Icon(icon),
                  title: Text(name),
                  trailing: Text(time,
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