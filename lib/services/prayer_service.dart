import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:campus_buddy_kict/models/prayer_times.dart';

class PrayerService {
  static const _baseUrl = 'https://api.aladhan.com/v1';

  Future<PrayerTimes> fetchKlTimes() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/timingsByCity'
            '?city=Kuala%20Lumpur&country=Malaysia&method=8'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;
    final date = data['date'] as Map<String, dynamic>;
    final gregorian = date['gregorian'] as Map<String, dynamic>;
    return PrayerTimes.fromJson(
        timings, gregorian['date'] as String? ?? '');
  }
}
