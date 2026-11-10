// Muhammad Naqib bin Rosli · 2310795
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  /// One place for the app's share text — used by Home and the links page.
  static Future<void> shareApp() async {
    await SharePlus.instance.share(
      ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
    );
  }
}