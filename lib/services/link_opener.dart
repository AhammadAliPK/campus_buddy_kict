import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpener {
  /// Tries to open [uri]; returns false (and shows nothing) if it can't.
  static Future<bool> open(String uriString, {LaunchMode mode = LaunchMode.externalApplication}) async {  // mode and uriString passed to launchUrl. mode = how to open the link (in app, in browser, etc.). uriString = the address to open (URL, phone number, email address, map coordinates, etc.)
    final uri = Uri.parse(uriString); // convert the string into a Uri object, which is what launchUrl wants. Uri = a structured address (URL, phone number, email address, map coordinates, etc.)
    try {
      return await launchUrl(uri, mode: mode);  // launchUrl = the function that actually opens the link. Returns true if it worked, false if it failed.
    } catch (e) {
      // No app registered for the scheme (e.g. geo:/mailto:/tel: on the
      // iOS Simulator), malformed URI, restricted m
      debugPrint('LinkOpener: could not launch $uriString — $e');
      return false;
    }
  }
}