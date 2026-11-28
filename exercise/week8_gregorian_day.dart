// Week 8 in-class exercise — model ONE day's "gregorian" part from
// GET /v1/hijriCalendarByCity (the response's data is a list of days).
//
// Shape of one day, from the JSON:
//   data[i] -> date -> gregorian -> {
//     "date": "01-12-2026",
//     "weekday": { "en": "Tuesday" },
//     "month":   { "number": 12, "en": "December" },
//     "year": "2026"
//   }
//
// Paste this whole file into DartPad and press Run.

// ignore_for_file: avoid_print

class GregorianDay {
  final String date, weekday, month, year;

  const GregorianDay({
    required this.date,
    required this.weekday,
    required this.month,
    required this.year,
  });

  factory GregorianDay.fromJson(Map<String, dynamic> json) {
    // weekday and month are nested maps — read "en" one level down.
    // ?. stops if the map is missing, ?? gives a dash instead of crashing.
    final weekday = json['weekday'] as Map<String, dynamic>?;
    final month = json['month'] as Map<String, dynamic>?;

    return GregorianDay(
      date: json['date'] as String? ?? '—',
      weekday: weekday?['en'] as String? ?? '—',
      month: month?['en'] as String? ?? '—',
      year: json['year'] as String? ?? '—',
    );
  }

  @override
  String toString() => '$weekday, $date ($month $year)';
}

void main() {
  // Full day.
  final full = {
    'date': '01-12-2026',
    'weekday': {'en': 'Tuesday'},
    'month': {'number': 12, 'en': 'December'},
    'year': '2026',
  };

  // The neighbour test: weekday missing entirely.
  final noWeekday = {
    'date': '02-12-2026',
    'month': {'number': 12, 'en': 'December'},
    'year': '2026',
  };

  print(GregorianDay.fromJson(full)); // Tuesday, 01-12-2026 (December 2026)
  print(GregorianDay.fromJson(noWeekday)); // —, 02-12-2026 (December 2026)
}
