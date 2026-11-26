import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:campus_buddy_kict/models/prayer_times.dart';

class PrayerService {
  PrayerService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client; // a test can pass in a fake client
  static const _baseUrl = 'https://api.aladhan.com/v1';

  /// Homework 1: the city is a parameter (method 8 = Malaysia).
  Future<PrayerTimes> fetchTimes(String city) async {
    final uri = Uri.parse('$_baseUrl/timingsByCity').replace(
      queryParameters: {'city': city, 'country': 'Malaysia', 'method': '8'},
    );
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;
    final date = data['date'] as Map<String, dynamic>;
    final gregorian = date['gregorian'] as Map<String, dynamic>;
    return PrayerTimes.fromJson(timings, gregorian['date'] as String? ?? '');
  }

  /// The lab's original call: Kuala Lumpur.
  Future<PrayerTimes> fetchKlTimes() => fetchTimes('Kuala Lumpur');
}
