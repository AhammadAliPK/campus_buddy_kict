/// The next prayer after [now], and how long until it.
/// [rows] are (name, 'HH:MM') pairs in the order of the day.
/// Returns null when every time today has passed (or none can be read).
({String name, Duration left})? nextPrayer(
  List<(String, String)> rows,
  DateTime now,
) {
  for (final (name, time) in rows) {
    final parts = time.split(':');
    if (parts.length != 2) continue;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) continue;
    final at = DateTime(now.year, now.month, now.day, h, m);
    if (at.isAfter(now)) return (name: name, left: at.difference(now));
  }
  return null;
}

/// "2h 15m" or "45m": rough is fine.
String formatLeft(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  return h > 0 ? '${h}h ${m}m' : '${m}m';
}
