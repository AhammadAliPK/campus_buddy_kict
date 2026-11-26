// Week 8 exercise: one day's "gregorian" part from GET /v1/hijriCalendarByCity.
// Example JSON (checked against the real API):
// {"date": "11-11-2026", "weekday": {"en": "Wednesday"},
//  "month": {"number": 11, "en": "November"}, "year": "2026", ...}
class GregorianDay {
  final String date, weekday, month, year;

  const GregorianDay({
    required this.date,
    required this.weekday,
    required this.month,
    required this.year,
  });

  // Survives missing fields: a missing weekday (or month) becomes '—'.
  factory GregorianDay.fromJson(Map<String, dynamic> json) {
    String nested(String key) =>
        ((json[key] as Map<String, dynamic>?)?['en'] as String?) ?? '—';
    return GregorianDay(
      date: json['date'] as String? ?? '—',
      weekday: nested('weekday'),
      month: nested('month'),
      year: json['year'] as String? ?? '—',
    );
  }
}
