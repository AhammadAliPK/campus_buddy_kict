
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  static Future<bool> open(String uriString) async {
    final uri = Uri.parse(uriString);

    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint(
        'LinkOpener: could not launch $uriString — $e',
      );
      return false;
    }
  }
}
