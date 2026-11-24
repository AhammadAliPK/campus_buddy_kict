import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:campus_buddy_kict/models/prayer_times.dart';

class PrayerService {
  static const String _url =
      'https://api.aladhan.com/v1/timingsByCity'
      '?city=Kuala%20Lumpur'
      '&country=Malaysia'
      '&method=8';

  static Future<PrayerTimes> fetchPrayerTimes() async {
    final response = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load prayer times: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    final data = body['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;

    return PrayerTimes.fromJson(timings);
  }
}
