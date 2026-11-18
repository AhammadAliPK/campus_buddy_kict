import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  static const campusHotline = '+60364215555';

  static Future<bool> open(Uri uri, {bool inApp = false}) async {
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(
      uri,
      mode: inApp
          ? LaunchMode.inAppBrowserView
          : LaunchMode.externalApplication,
    );
  }

  static Future<bool> callHotline() => open(Uri.parse('tel:$campusHotline'));

  static Future<bool> openMap() =>
      open(Uri.parse('geo:3.2528,101.7337?q=KICT+IIUM+Gombak'));

  static Future<bool> openWebsite({bool inApp = false}) =>
      open(Uri.parse('https://kulliyyah.iium.edu.my/kict/'), inApp: inApp);

  static Future<bool> openStudentPortal({bool inApp = false}) =>
      open(Uri.parse('https://my.iium.edu.my/'), inApp: inApp);

  static Future<bool> openIiumWebsite({bool inApp = false}) =>
      open(Uri.parse('https://www.iium.edu.my/'), inApp: inApp);

  static Future<bool> openCelpad({bool inApp = false}) =>
      open(Uri.parse('https://centre.iium.edu.my/celpad/'), inApp: inApp);

  static Future<bool> email(String address) => open(
    Uri(
      scheme: 'mailto',
      path: address,
      queryParameters: {
        'subject': 'Campus Buddy KICT enquiry',
        'body': 'Matric number: 2312887\nSection: 1',
      },
    ),
  );
}
