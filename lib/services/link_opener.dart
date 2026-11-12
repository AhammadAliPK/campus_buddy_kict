import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  /// Tries to open [uri]; returns false (and shows nothing) if it can't.
  static Future<bool> open(String uriString,
      {LaunchMode mode = LaunchMode.externalApplication}) async {
    final uri = Uri.parse(uriString);
    try {
      return await launchUrl(uri, mode: mode);
    } catch (e) {
      // No app registered for the scheme (e.g. geo:/mailto:/tel: on the
      // iOS Simulator), malformed URI, restricted mode...
      debugPrint('LinkOpener: could not launch $uriString — $e');
      return false;
    }
  }
}

