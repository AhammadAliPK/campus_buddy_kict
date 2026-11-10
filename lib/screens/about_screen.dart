import 'package:flutter/cupertino.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('About'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Campus Buddy KICT', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('Developer: Muhammad Syahmi Aiman', style: TextStyle(fontSize: 16)),
              SizedBox(height: 6),
              Text('Version: 1.0.0 (Week 6 Lab)', style: TextStyle(color: CupertinoColors.systemGrey)),
            ],
          ),
        ),
      ),
    );
  }
}