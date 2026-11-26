class PrayerTimes {
  final String imsak, fajr, sunrise, dhuhr, asr, sunset, maghrib, isha;
  final String gregorianDate;

  const PrayerTimes({
    required this.imsak,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.gregorianDate,
  });
  
  factory PrayerTimes.fromJson(Map<String, dynamic> timingsJson,
      String gregorianDate) {
    String t(String key) =>
      (timingsJson[key] as String?)?.split(' ')[0] ?? '—';
    return PrayerTimes(
      imsak: t('Imsak'),
      fajr: t('Fajr'),
      sunrise: t('Sunrise'),
      dhuhr: t('Dhuhr'),
      asr: t('Asr'),
      sunset: t('Sunset'),
      maghrib: t('Maghrib'),
      isha: t('Isha'),
      gregorianDate: gregorianDate,
    );
  }
}