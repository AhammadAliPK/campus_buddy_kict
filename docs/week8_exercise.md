# Week 8 exercise: model a second endpoint

Endpoint: `GET /v1/hijriCalendarByCity/{year}/{month}?city=…&country=…` returns
a whole Hijri month as a list. Each day has `date.gregorian`, for example
(checked against the real API):

```json
{"date": "11-11-2026", "weekday": {"en": "Wednesday"},
 "month": {"number": 11, "en": "November"}, "year": "2026"}
```

The factory for ONE day's gregorian part is in `lib/models/gregorian_day.dart`:

```dart
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
```

**Can it survive a missing weekday?** Yes. `json['weekday']` is null, the
`?.` stops before `['en']`, and `?? '—'` gives a dash instead of a crash. A
factory written as `json['weekday']['en'] as String` would throw
("NoSuchMethodError: The method '[]' was called on null"). `test/prayer_test.dart`
checks both the full day and the day without a weekday.
