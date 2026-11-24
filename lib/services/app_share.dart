import 'package:share_plus/share_plus.dart';

// Step 9: one share helper, used by both Home and the links page.
class AppShare {
  static void shareApp() => SharePlus.instance.share(
        ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'),
      );
}
