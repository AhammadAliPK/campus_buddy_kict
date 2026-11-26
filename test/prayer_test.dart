import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:campus_buddy_kict/models/gregorian_day.dart';
import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:campus_buddy_kict/screens/prayer_screen.dart';
import 'package:campus_buddy_kict/services/next_prayer.dart';
import 'package:campus_buddy_kict/services/prayer_service.dart';

// Shape copied from the real AlAdhan reply (KL, 26 Nov 2026).
const sampleBody = '''
{"code":200,"status":"OK","data":{
 "timings":{"Fajr":"05:42 (MYT)","Sunrise":"07:02","Dhuhr":"13:00","Asr":"16:25",
  "Sunset":"18:59","Maghrib":"18:59","Isha":"20:29","Imsak":"05:32"},
 "date":{"readable":"26 Nov 2026","gregorian":{"date":"26-11-2026"}}}}
''';

const sampleTimes = PrayerTimes(
  imsak: '05:32',
  fajr: '05:42',
  sunrise: '07:02',
  dhuhr: '13:00',
  asr: '16:25',
  sunset: '18:59',
  maghrib: '18:59',
  isha: '20:29',
  gregorianDate: '26-11-2026',
);

class FakeService extends PrayerService {
  FakeService({this.failFirst = false});
  bool failFirst;
  final cities = <String>[];

  @override
  Future<PrayerTimes> fetchTimes(String city) async {
    cities.add(city);
    if (failFirst) {
      failFirst = false;
      throw Exception('No internet');
    }
    return sampleTimes;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('fromJson keeps only HH:MM and survives a missing key', () {
    final t = PrayerTimes.fromJson({'Fajr': '05:42 (MYT)'}, '26-11-2026');
    expect(t.fajr, '05:42');
    expect(t.isha, '—');
  });

  test('service: request -> check -> dig', () async {
    late Uri asked;
    final service = PrayerService(
      client: MockClient((req) async {
        asked = req.url;
        return http.Response(sampleBody, 200);
      }),
    );
    final t = await service.fetchKlTimes();
    expect(asked.queryParameters['city'], 'Kuala Lumpur');
    expect(asked.queryParameters['method'], '8');
    expect(t.fajr, '05:42');
    expect(t.imsak, '05:32');
    expect(t.sunset, '18:59');
    expect(t.gregorianDate, '26-11-2026');
  });

  test('service: a non-200 reply throws', () async {
    final service = PrayerService(
      client: MockClient((_) async => http.Response('oops', 500)),
    );
    expect(service.fetchTimes('Kuantan'), throwsException);
  });

  test('next prayer and time left', () {
    final rows = [
      ('Fajr', '05:42'),
      ('Dhuhr', '13:00'),
      ('Asr', '16:25'),
      ('Maghrib', '18:59'),
      ('Isha', '20:29'),
    ];
    final at14 = nextPrayer(rows, DateTime(2026, 11, 26, 14, 10))!;
    expect(at14.name, 'Asr');
    expect(formatLeft(at14.left), '2h 15m');
    expect(nextPrayer(rows, DateTime(2026, 11, 26, 21, 0)), isNull);
    expect(formatLeft(const Duration(minutes: 45)), '45m');
  });

  test('exercise: gregorian day survives a missing weekday', () {
    final json = jsonDecode(
      '{"date":"11-11-2026","weekday":{"en":"Wednesday"},'
      '"month":{"number":11,"en":"November"},"year":"2026"}',
    ) as Map<String, dynamic>;
    final d = GregorianDay.fromJson(json);
    expect(
      [d.date, d.weekday, d.month, d.year],
      ['11-11-2026', 'Wednesday', 'November', '2026'],
    );
    final noWeekday = GregorianDay.fromJson({
      'date': '11-11-2026',
      'year': '2026',
    });
    expect(noWeekday.weekday, '—');
  });

  testWidgets('screen: data, next prayer highlighted, city choice', (
    tester,
  ) async {
    final service = FakeService();
    await tester.pumpWidget(
      MaterialApp(
        home: PrayerScreen(
          service: service,
          clock: () => DateTime(2026, 11, 26, 14, 10),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('26-11-2026 · Malaysia method'), findsOneWidget);
    expect(find.text('Asr in 2h 15m'), findsOneWidget);
    expect(find.text('Asr · next'), findsOneWidget);
    for (final name in ['Imsak', 'Fajr', 'Sunrise', 'Dhuhr', 'Sunset']) {
      expect(find.text(name), findsOneWidget);
    }

    await tester.tap(find.text('Kuala Lumpur'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kuantan').last);
    await tester.pumpAndSettle();
    expect(find.text('Prayer times · Kuantan'), findsOneWidget);
    expect(service.cities.last, 'Kuantan');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('prayer_city'), 'Kuantan');
  });

  testWidgets('screen: error with Retry, then data', (tester) async {
    final service = FakeService(failFirst: true);
    await tester.pumpWidget(
      MaterialApp(
        home: PrayerScreen(
          service: service,
          clock: () => DateTime(2026, 11, 26, 14, 10),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    expect(find.textContaining('Could not load times'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Asr in 2h 15m'), findsOneWidget);
  });

  testWidgets('screen: remembers the saved city', (tester) async {
    SharedPreferences.setMockInitialValues({'prayer_city': 'Johor Bahru'});
    final service = FakeService();
    await tester.pumpWidget(MaterialApp(home: PrayerScreen(service: service)));
    await tester.pumpAndSettle();
    expect(find.text('Prayer times · Johor Bahru'), findsOneWidget);
    expect(service.cities.last, 'Johor Bahru');
  });
}
