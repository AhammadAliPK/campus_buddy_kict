import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// A service class: no screen, no widgets - just one job.
/// It opens any URI (https:, tel:, mailto:, geo:) with the right app.
class LinkOpener {
  /// Tries to open [uriString]; returns false (and shows nothing) if it can't.
  static Future<bool> open(String uriString) async {
    final uri = Uri.parse(uriString);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // No app registered for the scheme (e.g. geo:/mailto:/tel: on the
      // iOS Simulator), malformed URI, restricted mode...
      debugPrint('LinkOpener: could not launch $uriString — $e');
      return false;
    }
  }
}