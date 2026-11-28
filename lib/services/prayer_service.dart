import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:campus_buddy_kict/models/prayer_times.dart';

class PrayerService {
  Map<String, dynamic> _readMap(dynamic value, String path) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    throw FormatException(
      'Missing or invalid JSON object at: $path',
    );
  }

  Future<PrayerTimes> fetchKlTimes() async {
    final uri = Uri.https(
      'api.aladhan.com',
      '/v1/timingsByCity',
      {
        'city': 'Kuala Lumpur',
        'country': 'Malaysia',
        'method': '8',
      },
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final body = _readMap(
      jsonDecode(response.body),
      'response',
    );

    if (body['code'] != 200) {
      throw Exception(
        'API returned: ${body['status']}',
      );
    }

    final data = _readMap(
      body['data'],
      'data',
    );

    final timings = _readMap(
      data['timings'],
      'data.timings',
    );

    final date = _readMap(
      data['date'],
      'data.date',
    );

    final gregorian = _readMap(
      date['gregorian'],
      'data.date.gregorian',
    );

    return PrayerTimes.fromJson(
      timings,
      gregorian['date'] as String? ?? '',
    );
  }
}