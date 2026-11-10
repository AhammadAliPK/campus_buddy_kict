import 'package:share_plus/share_plus.dart';

/// One place for the "share this app" text, used by Home and the links page.
class AppShare {
  static Future<void> share() => SharePlus.instance.share(
      ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'));
}
