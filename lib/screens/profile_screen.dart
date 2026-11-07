import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Default state values
  static const String _defaultNickname = 'Guest Student';
  static const String _defaultBio =
      'Kulliyyah of ICT Year 2. Loves nasi ayam and clean code.';
  static const String _defaultMatric = '202300000';

  String _nickname = _defaultNickname;
  String _bio = _defaultBio;
  String _matric = _defaultMatric;

  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _matricCtrl = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl.text = _nickname;
    _bioCtrl.text = _bio;
    _matricCtrl.text = _matric;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    _matricCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_editing) {
        // Homework 2
        final trimmedNickname = _nicknameCtrl.text.trim();
        _nickname = trimmedNickname.isEmpty ? _defaultNickname : trimmedNickname;

        _bio = _bioCtrl.text.trim();
        _matric = _matricCtrl.text.trim();
      }
      _editing = !_editing;
    });
  }

  // Part D: Reset function
  void _resetFields() {
    setState(() {
      _nickname = _defaultNickname;
      _bio = _defaultBio;
      _matric = _defaultMatric;

      _nicknameCtrl.text = _defaultNickname;
      _bioCtrl.text = _defaultBio;
      _matricCtrl.text = _defaultMatric;
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
            // Homework #3: Local Asset Image fallback / toggle
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/me.jpg'),
            ),
            const SizedBox(height: 12),
            if (_editing) ...[
              TextField(
                controller: _nicknameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              // Homework #1: Matric number field
              TextField(
                controller: _matricCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Matric Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bioCtrl,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              const SizedBox(height: 8),
              // Part D: Reset button
              TextButton.icon(
                onPressed: _resetFields,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ] else ...[
              Text(
                _nickname,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Homework 1
              Text(
                _matric,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 8),
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