import 'package:campus_buddy_kict/models/prayer_times.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses prayer times and removes the timezone suffix', () {
    final times = PrayerTimes.fromJson({
      'Fajr': '05:50 (MYT)',
      'Sunrise': '07:02 (MYT)',
      'Dhuhr': '13:10 (MYT)',
      'Asr': '16:20 (MYT)',
      'Maghrib': '19:15 (MYT)',
      'Isha': '20:25 (MYT)',
    }, '24-11-2026');

    expect(times.fajr, '05:50');
    expect(times.sunrise, '07:02');
    expect(times.dhuhr, '13:10');
    expect(times.asr, '16:20');
    expect(times.maghrib, '19:15');
    expect(times.isha, '20:25');
    expect(times.gregorianDate, '24-11-2026');
  });

  test('uses a dash when an API timing is missing', () {
    final times = PrayerTimes.fromJson({}, '24-11-2026');

    expect(times.fajr, '—');
    expect(times.isha, '—');
  });
}
