class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    String time(String key) {
      final value = json[key] as String?;
      if (value == null || value.isEmpty) {
        return '—';
      }

      // Sesetengah API response mungkin tambah timezone,
      // contohnya "05:50 (MYT)".
      return value.split(' ').first;
    }

    return PrayerTimes(
      fajr: time('Fajr'),
      dhuhr: time('Dhuhr'),
      asr: time('Asr'),
      maghrib: time('Maghrib'),
      isha: time('Isha'),
    );
  }
}
