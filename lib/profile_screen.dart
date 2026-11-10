import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'Guest Student';
  String _bio = 'Kulliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  bool _editing = false;

  // NEW: controllers let us read the text the user typed
  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  // NEW: runs ONCE, when the screen is first created
  @override
  void initState() {
    super.initState();
    _nicknameCtrl.text = _nickname; // pre-fill the boxes
    _bioCtrl.text = _bio;
  }

  // NEW: runs ONCE, when the screen is destroyed. Clean up.
  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_editing) {
        // NEW: leaving edit mode, so save what was typed
        _nickname = _nicknameCtrl.text.trim();
        _bio = _bioCtrl.text.trim();
      }
      _editing = !_editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            ),
            const SizedBox(height: 12),
            if (_editing) ...[ // CHANGED: now a list of several widgets
              TextField( // NEW
                controller: _nicknameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField( // NEW
                controller: _bioCtrl,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon( // NEW
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ] else ...[
              Text(
                _nickname,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _bio,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}