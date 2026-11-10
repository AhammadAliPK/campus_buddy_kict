
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  /// Tries to open [uri]; returns false if it can't.
  static Future<bool> open(
    String uriString, {
    bool inApp = false,
  }) async {
    final uri = Uri.parse(uriString);

    try {
      return await launchUrl(
        uri,
        mode: inApp &&
                (uri.scheme == 'http' || uri.scheme == 'https')
            ? LaunchMode.inAppBrowserView
            : LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('LinkOpener: could not launch $uriString — $e');
      return false;
    }
  }
}
