import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:campus_buddy_kict/models/prayer_times.dart';

class PrayerService {
  static const _baseUrl = 'https://api.aladhan.com/v1';

  Future<PrayerTimes> fetchKlTimes() async {
    // Printed so Part C can show how many requests fire.
    debugPrint('PrayerService: fetching KL prayer times...');

    // 1. Request — wait for the answer, but never longer than 10 s.
    final response = await http
        .get(Uri.parse('$_baseUrl/timingsByCity'
            '?city=Kuala%20Lumpur&country=Malaysia&method=8'))
        .timeout(const Duration(seconds: 10));

    // 2. Check — 200 means OK, anything else is an error.
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    // 3. Dig — body -> data -> timings / date -> gregorian, one level at a time.
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;
    final date = data['date'] as Map<String, dynamic>;
    final gregorian = date['gregorian'] as Map<String, dynamic>;

    return PrayerTimes.fromJson(
        timings, gregorian['date'] as String? ?? '');
  }
}
