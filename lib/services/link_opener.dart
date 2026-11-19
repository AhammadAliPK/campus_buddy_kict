
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  static Future<bool> open(
    String uriString, {
    bool inApp = false,
  }) async {
    try {
      final uri = Uri.parse(uriString);

      final mode = inApp &&
              (uri.scheme == 'https' || uri.scheme == 'http')
          ? LaunchMode.inAppBrowserView
          : LaunchMode.externalApplication;

      return await launchUrl(
        uri,
        mode: mode,
      );
    } catch (e) {
      debugPrint(
        'LinkOpener: could not launch $uriString — $e',
      );
      return false;
    }
  }
}
