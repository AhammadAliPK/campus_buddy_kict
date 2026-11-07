import 'package:flutter/material.dart';

/// Tiny stub page; becomes real in Week 7 (links) and Week 8 (prayer times).
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(note)),
    );
  }
}
