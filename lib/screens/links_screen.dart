import 'dart:io';         

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart'; 
import 'package:share_plus/share_plus.dart';                 
import 'package:url_launcher/url_launcher.dart';   

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
  LinkItem('CELPAD', 'Centre for e-Learning & Professional Advancement',
      Icons.book, 'https://centre.iium.edu.my/celpad/'),
];

class LinksScreen extends StatefulWidget { // 
  const LinksScreen({super.key}); 

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  bool _AppView = true;  // true = open links in the app, false = open in browser/app. Default = true
  Future<void> _open(BuildContext context, String uri, {LaunchMode mode = LaunchMode.externalApplication}) async {  // try to open the link; if it fails, show a SnackBar error message. context = the screen that called this function
    final ok = await LinkOpener.open(uri, mode: mode);  // try to open; true = worked, false = failed
    if (!ok && context.mounted) {           // failed AND this screen is still showing?
      ScaffoldMessenger.of(context).showSnackBar( 
        SnackBar(content: Text('Cannot open $uri on this device')), // tell the user that it failed. SnackBar = a temporary message at the bottom of the screen
      );
    }
  }

  void _callHotline(BuildContext context) => // open the phone dialer with the number typed in. If the device can't do that, show a SnackBar error message.
      _open(context, 'tel:+60361964000');   
   // tel: → phone dialer with the number typed in
  void _emailAdvisor(BuildContext context) => _open(context,  // open the email app with the address, subject, and body prefilled. If the device can't do that, show a SnackBar error message.
      'mailto:ahammad.ali@live.iium.edu.my?subject=A%20warm%20welcome'          // mailto: → email app
      '&body=Salam%20Sir%2C%20Welcome%20to%20the%20mobility%20group.%20My%20matric%20number%20is%202317327.');

      // %20 = space, %2C = comma (URL-encoding). The two lines join into ONE string.
  void _openMap(BuildContext context) => _open( // open the map app with the coordinates. If the device can't do that, show a SnackBar error message.
      context,
      Platform.isAndroid                                  // is this an Android phone?
          ? 'geo:3.0717,101.7182?q=IIUM+Gombak+Campus'    //   yes → geo: (Android maps)
          : 'https://maps.apple.com/?q=IIUM+Gombak+Campus' //   no → Apple Maps web link
            '&ll=3.0717,101.7182');

  void _openKuantanMap(BuildContext context) => _open( // open the map app with the coordinates. If the device can't do that, show a SnackBar error message.
      context,
      Platform.isAndroid                                  // is this an Android phone?
          ? 'geo:3.844147421686299,103.30379683833114?q=IIUM+Kuantan+Campus'    //   yes → geo: (Android maps)
          : 'https://maps.apple.com/?q=IIUM+Kuantan+Campus' //   no → Apple Maps web link
            '&ll=3.844147421686299,103.30379683833114');

  void _share(BuildContext context) => SharePlus.instance.share(    // open the share sheet
      ShareParams(text: 'Campus Buddy KICT — built in CSCI 4311 at IIUM.'));  
  // ShareParams = the content to share. text = the text to share. Can also share files, URLs, etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus links')),
      body: ListView(
        padding: const EdgeInsets.all(12),    // space around the edges of the list
        children: [
          SwitchListTile(   // a switch that turns ON/OFF the in-app browser. SwitchListTile = a ListTile with a switch on the right
            title: const Text('Open links in this app'),  // the text on the left
            value: _AppView,                        // true = switch ON, false = switch OFF
            onChanged: (v) => setState(() => _AppView = v),  // tap → change the value and redraw the screen
          ),
          ..._links.map((l) => Card(      // each link when tapped → open the link. Card = a rectangle with a shadow, like a playing card
                child: ListTile(
                  leading: Icon(l.icon), // the icon on the left
                  title: Text(l.title),
                  subtitle: Text(l.subtitle),
                  trailing: const Icon(Icons.open_in_new), // the "open in new window" icon = "opens something"
                  onTap: () => _open(context, l.uri, mode: _AppView ? LaunchMode.inAppBrowserView : LaunchMode.externalApplication),      // switch ON → browser inside your app   // switch OFF → real Chrome browser
                ),
              )),
          const Divider(),                 // a thin line separating sections
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Gombak Campus map'),
            subtitle: const Text('IIUM Gombak on Google Maps'),
            onTap: () => _openMap(context),   // call the function that opens the map app with the coordinates. If the device can't do that, show a SnackBar error message.
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Kuantan Campus map'),
            subtitle: const Text('IIUM Kuantan on Google Maps'),
            onTap: () => _openKuantanMap(context),   // call the function that opens the map app with the coordinates. If the device can't do that, show a SnackBar error message.
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