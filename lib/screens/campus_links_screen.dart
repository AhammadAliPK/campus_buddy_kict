import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/services/link_opener.dart';

class CampusLinksScreen extends StatelessWidget {
  const CampusLinksScreen({super.key});

Future<void> _open(BuildContext context, String uri) async {
 final ok = await LinkOpener.open(uri);
 if (!ok && context.mounted) {
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(content: Text('Cannot open $uri on this device')),
 );
 }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Links')),
      body: const Center(child: Text('Campus links coming in Week 7')),
    );
  }
}