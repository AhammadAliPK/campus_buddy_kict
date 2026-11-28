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
    Map<String, dynamic> timingsJson,
    String gregorianDate,
  ) {
    String t(String key) {
      final value = timingsJson[key] as String?;
      return value?.split(' ').first ?? '-';
    }

    return PrayerTimes(
      fajr: t('Fajr'),
      sunrise: t('Sunrise'),
      dhuhr: t('Dhuhr'),
      asr: t('Asr'),
      maghrib: t('Maghrib'),
      isha: t('Isha'),
      gregorianDate: gregorianDate,
    );
  }
}