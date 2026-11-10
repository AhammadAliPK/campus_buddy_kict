import 'dart:io';         

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart'; 
import 'package:share_plus/share_plus.dart';                 

class LinkItem {                           // blueprint: what ONE link contains and looks like
  final String title, subtitle;            // two text fields declared in one line
  final IconData icon;
  final String uri;                        // the address to open
  const LinkItem(this.title, this.subtitle, this.icon, this.uri);
}

const _links = [                           // the website links, as DATA (like sampleCourses)
  LinkItem('IIUM portal', 'Student portal & registration',
      Icons.school, 'https://my.iium.edu.my'),
  LinkItem('IIUM website', 'News & announcements',
      Icons.public, 'https://www.iium.edu.my'),
  LinkItem('Library', 'Find books & e-resources',
      Icons.local_library, 'https://division.iium.edu.my/lib'),
  LinkItem('KICT', 'Kuliyyah of ICT',
      Icons.computer, 'https://www.iium.edu.my/kict'),
];

class LinksScreen extends StatelessWidget { // LinksScreen is a StatelessWidget because it has no changing state. It just shows a list of links and responds to taps.
  const LinksScreen({super.key}); 

  Future<void> _open(BuildContext context, String uri) async {  // try to open the link; if it fails, show a SnackBar error message. context = the screen that called this function
    final ok = await LinkOpener.open(uri);  // try to open; true = worked, false = failed
    if (!ok && context.mounted) {           // failed AND this screen is still showing?
      ScaffoldMessenger.of(context).showSnackBar( 
        SnackBar(content: Text('Cannot open $uri on this device')), // tell the user that it failed. SnackBar = a temporary message at the bottom of the screen
      );
    }
  }

  void _callHotline(BuildContext context) => // open the phone dialer with the number typed in. If the device can't do that, show a SnackBar error message.
      _open(context, 'tel:+60361964000');   // tel: → phone dialer with the number typed in

  void _emailAdvisor(BuildContext context) => _open(context,  // open the email app with the address, subject, and body prefilled. If the device can't do that, show a SnackBar error message.
      'mailto:advisor@iium.edu.my?subject=Advising%20session'          // mailto: → email app
      '&body=Assalamualaikum%2C%20I%20would%20like%20to%20book%20a%20slot.');
      // %20 = space, %2C = comma (URL-encoding). The two lines join into ONE string.

  void _openMap(BuildContext context) => _open( // open the map app with the coordinates. If the device can't do that, show a SnackBar error message.
      context,
      Platform.isAndroid                                  // is this an Android phone?
          ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'    //   yes → geo: (Android maps)
          : 'https://maps.apple.com/?q=IIUM+Gombak+Campus' //   no → Apple Maps web link
            '&ll=3.0717,101.7182');

  void _share(BuildContext context) => SharePlus.instance.share(    // open the share sheet
      ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'));  // ShareParams = the content to share. text = the text to share. Can also share files, URLs, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ..._links.map((l) => Card(      // each link when tapped → open the link. Card = a rectangle with a shadow, like a playing card
                child: ListTile(
                  leading: Icon(l.icon), // the icon on the left
                  title: Text(l.title),
                  subtitle: Text(l.subtitle),
                  trailing: const Icon(Icons.open_in_new), // the "open in new window" icon = "opens something"
                  onTap: () => _open(context, l.uri),      // tap → open that address
                ),
              )),
          const Divider(),                 // a thin line separating sections
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Campus map'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap(context),   // call the function that opens the map app with the coordinates. If the device can't do that, show a SnackBar error message.
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call university hotline'),
            subtitle: const Text('+60 3-6196 4000'),
            onTap: () => _callHotline(context),   //call the function that opens the phone dialer with the number typed in. If the device can't do that, show a SnackBar error message.
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email academic advisor'),
            subtitle: const Text('Prefilled subject & body'),
            onTap: () => _emailAdvisor(context),    // call the function that opens the email app with the address, subject, and body prefilled. If the device can't do that, show a SnackBar error message.
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Campus Buddy KICT'),
            onTap: () => _share(context),   // call the function that opens the share sheet
          ),
        ],
      ),
    );
  }
}