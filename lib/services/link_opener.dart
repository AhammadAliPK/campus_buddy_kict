
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  static Future<bool> open(
    String uriString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.parse(uriString);

    try {
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
