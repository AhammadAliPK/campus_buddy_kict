
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  static Future<bool> open(
      String uriString, {
        bool inApp = false,
      }) async {
    final uri = Uri.parse(uriString);

    try {
      // Only HTTP and HTTPS links can use the in-app browser.
      final isWebLink =
          uri.scheme == 'https' || uri.scheme == 'http';

      final mode = inApp && isWebLink
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
