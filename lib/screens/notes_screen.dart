import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 60),
            SizedBox(height: 12),
            Text('Notes arrive in Week 11',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center),
          ],
        )
      ),
    );
  }
}