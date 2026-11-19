import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  /// Tries to open [uriString]; returns false (and shows nothing) if it can't.
  /// [inApp] true = open websites inside the app (Chrome Custom Tab on
  /// Android, SFSafariViewController on iOS). false = the normal browser app.
  static Future<bool> open(String uriString, {bool inApp = false}) async {
    final uri = Uri.parse(uriString);
    try {
      return await launchUrl(
        uri,
        mode: inApp
            ? LaunchMode.inAppBrowserView
            : LaunchMode.externalApplication,
      );
    } catch (e) {
      // No app registered for the scheme (e.g. geo:/mailto:/tel: on the
      // iOS Simulator), malformed URI, restricted mode...
      debugPrint('LinkOpener: could not launch $uriString — $e');
      return false;
    }
  }
}