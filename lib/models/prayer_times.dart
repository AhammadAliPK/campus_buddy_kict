class PrayerTimes {
  final String fajr, sunrise, dhuhr, asr, maghrib, isha;
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
      Map<String, dynamic> timingsJson, String gregorianDate) {
    String t(String key) =>
        (timingsJson[key] as String?)?.split(' ')[0] ?? '—';
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
