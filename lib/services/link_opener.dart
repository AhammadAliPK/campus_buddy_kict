import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  /// Tries to open [uriString]; returns false if it can't.
  static Future<bool> open(
    String uriString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.parse(uriString);
    try {
      return await launchUrl(uri, mode: mode);
    } catch (e) {
      // No app registered for the scheme, malformed URI, etc.
      debugPrint('LinkOpener: could not launch $uriString — $e');
      return false;
    }
  }
}
