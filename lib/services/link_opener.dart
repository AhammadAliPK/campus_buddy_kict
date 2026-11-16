import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  static Future<bool> open(
    String uriString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      final uri = Uri.parse(uriString);
      return await launchUrl(uri, mode: mode);
    } catch (error) {
      debugPrint('LinkOpener: could not launch $uriString: $error');
      return false;
    }
  }
}