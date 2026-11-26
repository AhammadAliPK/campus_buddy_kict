import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  static Future<bool> open(String uriString) async {
    try {
      return await launchUrl(
        Uri.parse(uriString),
        mode: LaunchMode.externalApplication,
      );
    } catch (error) {
      debugPrint('LinkOpener: could not launch $uriString — $error');
      return false;
    }
  }
}
