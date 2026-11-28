class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String gregorianDate;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.gregorianDate,
  });

  factory PrayerTimes.fromJson(
    Map<String, dynamic> timingJson,
    String gregorianDate,
  ) {
    String time(String key) =>
      (timingJson[key] as String?)?.split(' ')[0] ?? '-';

    return PrayerTimes(
      fajr: time('Fajr'),
      sunrise: time('Sunrise'),
      dhuhr: time('Dhuhr'),
      asr: time('Asr'),
      maghrib: time('Maghrib'),
      isha: time('Isha'),
      gregorianDate: gregorianDate,
    );
  }
}